use lzw::{Encoder, LsbWriter};

/// LZW encodes the frame and returns the image data as 255 bytes chunks.
pub fn lzw_encode(image_data: &[u8], code_size: u8) -> Vec<u8> {
    let mut compressed = vec![];
    {
        let mut enc = Encoder::new(LsbWriter::new(&mut compressed), code_size).unwrap();
        enc.encode_bytes(&image_data).unwrap();
    }

    compressed = chunkify(compressed);
    compressed.insert(0, code_size);
    compressed.push(0);

    compressed
}

fn chunkify(mut data: Vec<u8>) -> Vec<u8> {
    if data.len() > 255 {
        let chunk = data.split_off(255);
        data.insert(0, 255);
        data.append(&mut chunkify(chunk));
    } else {
        let l = data.len() as u8;
        data.insert(0, l);
    }

    data
}
