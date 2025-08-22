use std::{fs::File, io::Read};

use anyhow::Result;
use flutter_rust_bridge::frb;
use qrcode::{bits::Bits, EcLevel};
use raptorq::Encoder;

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
    let encoder = Encoder::with_defaults(&data, max_length as u16);
    let packets = encoder.get_encoded_packets(params.repair);
    let ser_packets = packets.iter().map(|p| p.serialize()).collect::<Vec<_>>();

    Ok(ser_packets)
}

fn ec_level_of(level: u8) -> EcLevel {
    match level {
        0 => EcLevel::L,
        1 => EcLevel::M,
        2 => EcLevel::Q,
        3 => EcLevel::H,
        _ => unreachable!()
    }
}

#[flutter_rust_bridge::frb(init)]
pub fn init_app() {
    // Default utilities - feel free to customize
    flutter_rust_bridge::setup_default_user_utils();
}
