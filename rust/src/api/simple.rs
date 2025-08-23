use std::{fs::File, io::Read};

use anyhow::Result;
use flutter_rust_bridge::frb;
use qrcode::{bits::Bits, EcLevel};
use raptorq::{Decoder, Encoder, EncodingPacket, ObjectTransmissionInformation};

pub struct RaptorQParams {
    pub version: u16,
    pub ec_level: u8,
    pub repair: u32,
}

#[frb]
pub async fn encode(path: &str, params: RaptorQParams) -> Result<Vec<Vec<u8>>> {
    let mut file = File::open(path)?;
    let mut data = vec![];
    file.read_to_end(&mut data)?;
    let ecl = ec_level_of(params.ec_level);
    let version = qrcode::Version::Normal(params.version as i16);
    let bits = Bits::new(version);
    let max_length = bits.max_len(ecl)? / 8;
    let max_length = max_length - 20; // header size = raptor params 12 + qr header 4 + packet header 4
    let encoder = Encoder::with_defaults(&data, max_length as u16);
    let header = encoder.get_config().serialize();
    let packets = encoder.get_encoded_packets(params.repair);
    let ser_packets = packets
        .iter()
        .map(|p| {
            let mut packet = header.to_vec();
            packet.extend(p.serialize());
            packet
        })
        .collect::<Vec<_>>();

    Ok(ser_packets)
}

#[frb]
pub async fn decode(mut packets: Vec<Vec<u8>>) -> Result<Option<Vec<u8>>> {
    if packets.is_empty() {
        return Ok(None);
    }
    let mut payloads = vec![];
    for packet in packets.iter_mut() {
        let len = packet.len();
        for i in 0..len {
            let c = if i + 1 < len { packet[i + 1] >> 4 } else { 0 };
            packet[i] = (packet[i] << 4) | c;
        }
        let len = (u16::from_be_bytes(packet[0..2].try_into().unwrap())) as usize;
        let payload = &packet[2..len+2];
        payloads.push(payload);
    }

    let header = &payloads.first().unwrap()[0..12];
    let oti = ObjectTransmissionInformation::deserialize(header.try_into().unwrap());
    let mut decoder = Decoder::new(oti);
    for ser_packet in payloads {
        let packet = EncodingPacket::deserialize(&ser_packet[12..]);
        decoder.add_new_packet(packet);
    }
    let result = decoder.get_result();

    Ok(result)
}

fn ec_level_of(level: u8) -> EcLevel {
    match level {
        0 => EcLevel::L,
        1 => EcLevel::M,
        2 => EcLevel::Q,
        3 => EcLevel::H,
        _ => unreachable!(),
    }
}

#[flutter_rust_bridge::frb(init)]
pub fn init_app() {
    // Default utilities - feel free to customize
    flutter_rust_bridge::setup_default_user_utils();
}
