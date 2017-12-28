#[macro_use]
extern crate rustler;
#[macro_use]
extern crate lazy_static;
extern crate rand;
extern crate lzw;

mod game;
mod gif;

use std::sync::RwLock;
use rustler::{NifEnv, NifTerm, NifResult, NifEncoder};
use rustler::resource::ResourceArc;
use rustler::types::OwnedNifBinary;
use rustler::schedule::NifScheduleFlags::DirtyCpu;

use game::{Board, Direction};

mod atoms {
    rustler_atoms! {
        atom ok;
        atom error;
        //atom __true__ = "true";
        //atom __false__ = "false";
    }
}

rustler_export_nifs! {
    "Elixir.Snake.Encoder.GIF",
    [
        ("new_game", 0, new_game, DirtyCpu),
        ("next_frame", 1, next_frame, DirtyCpu),
        ("turn", 2, turn, DirtyCpu),
    ],
    Some(on_load)
}

struct Buffer {
    board: RwLock<Board>,
}


fn on_load<'a>(env: NifEnv<'a>, _load_info: NifTerm<'a>) -> bool {
    resource_struct_init!(Buffer, env);
    true
}

fn new_game<'a>(env: NifEnv<'a>, _args: &[NifTerm<'a>]) -> NifResult<NifTerm<'a>> {
    let board = Board::new();
    let buffer = Buffer { board: RwLock::new(board) };
    let image = buffer.board.write().unwrap().current_frame();

    let mut binary = OwnedNifBinary::new(image.len()).unwrap();
    binary.as_mut_slice().clone_from_slice(&image);

    Ok(
        (atoms::ok(), ResourceArc::new(buffer), binary.release(env)).encode(env),
    )
}


fn next_frame<'a>(env: NifEnv<'a>, args: &[NifTerm<'a>]) -> NifResult<NifTerm<'a>> {
    let buffer: ResourceArc<Buffer> = args[0].decode()?;

    let result = buffer.board.write().unwrap().next_frame();
    match result {
        Ok(image) => {
            let mut binary = OwnedNifBinary::new(image.len()).unwrap();
            binary.as_mut_slice().clone_from_slice(&image);

            Ok((atoms::ok(), binary.release(env)).encode(env))
        }
        Err(err) => Ok((atoms::error(), err.encode(env)).encode(env)),
    }
}

fn turn<'a>(env: NifEnv<'a>, args: &[NifTerm<'a>]) -> NifResult<NifTerm<'a>> {
    let buffer: ResourceArc<Buffer> = args[0].decode()?;
    let direction = args[1].atom_to_string()?;

    buffer.board.write().unwrap().turn(&direction);

    Ok(atoms::ok().encode(env))
}
