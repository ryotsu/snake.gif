mod game;
mod gif;

use rustler::types::binary::{Binary, OwnedBinary};
use rustler::{Atom, Env, Error, ResourceArc, Term};
use std::sync::RwLock;

use game::Board;

mod atoms {
    rustler::atoms! {
        ok,
        error,
    }
}

rustler::init!(
    "Elixir.Snake.Encoder",
    [new_game, next_frame, turn],
    load = load
);

fn load(env: Env, _: rustler::Term) -> bool {
    on_load(env)
}

struct Buffer {
    board: RwLock<Board>,
}

fn on_load(env: Env) -> bool {
    rustler::resource!(Buffer, env);
    true
}

#[rustler::nif(schedule = "DirtyCpu")]
fn new_game(env: Env) -> (ResourceArc<Buffer>, Binary) {
    let buffer = Buffer {
        board: RwLock::new(Board::new()),
    };

    let image = buffer.board.write().unwrap().current_frame();

    let mut binary = OwnedBinary::new(image.len()).unwrap();
    binary.as_mut_slice().clone_from_slice(&image);

    (ResourceArc::new(buffer), binary.release(env))
}

#[rustler::nif(schedule = "DirtyCpu")]
fn next_frame(env: Env, buffer: ResourceArc<Buffer>) -> Result<Binary, String> {
    let result = buffer.board.write().unwrap().next_frame();
    match result {
        Ok(image) => {
            let mut binary = OwnedBinary::new(image.len()).unwrap();
            binary.as_mut_slice().clone_from_slice(&image);

            Ok(binary.release(env))
        }
        Err(err) => Err(err.into()),
    }
}

#[rustler::nif(schedule = "DirtyCpu")]
fn turn(buffer: ResourceArc<Buffer>, direction: Term) -> Result<Atom, Error> {
    let direction = direction.atom_to_string()?;

    buffer.board.write().unwrap().turn(&direction);

    Ok(atoms::ok())
}
