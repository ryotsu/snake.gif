use std::collections::{VecDeque, HashSet};
use rand::{thread_rng, Rng};
use super::gif::lzw_encode;

#[repr(u8)]
#[derive(Clone)]
pub enum Direction {
    Up,
    Down,
    Left,
    Right,
}

const COORDS: [(i8, i8); 4] = [(-1, 0), (1, 0), (0, -1), (0, 1)];

pub struct Board {
    field: Vec<Vec<u8>>,
    snake: VecDeque<(u8, u8)>,
    snake_set: HashSet<u16>,
    food: (u8, u8),
    direction: Direction,
}

impl Board {
    /// Returns a new game board with the snake of length 4 at the bottom left
    pub fn new() -> Self {
        let field = vec![vec![0; 128]; 128];
        let mut snake = VecDeque::new();
        let mut snake_set = HashSet::new();
        for i in 28..32 {
            snake.push_back((31, i as u8));
            snake_set.insert(31 * 32 + i);
        }
        let food = Self::food_location(&snake_set);
        let direction = Direction::Left;

        Board {
            field,
            snake,
            snake_set,
            food,
            direction,
        }
    }

    /// Turns the head of the snake in the given direction
    ///
    /// # Arguments
    ///
    /// * `dir` - A string slice which is either `"up"`, `"down"`, `"left"` or `"right"`
    ///
    pub fn turn(&mut self, dir: &str) {
        use Direction::*;

        let new_dir = match dir {
            "up" => Up,
            "down" => Down,
            "left" => Left,
            _ => Right,
        };

        let (y1, x1) = COORDS[self.direction.clone() as usize];
        let (y2, x2) = COORDS[new_dir.clone() as usize];

        if (y1 + y2, x1 + x2) != (0, 0) {
            self.direction = new_dir;
        }
    }

    /// Returns the LZW encoded image data of the board
    pub fn current_frame(&mut self) -> Vec<u8> {
        self.paint();
        let input = &self.field.concat();
        lzw_encode(input, 2)
    }

    /// Moves the snake one step ahead in the direction of the head and checks game status.
    /// Returns image data of the next frame if available or an error is the game is over.
    pub fn next_frame(&mut self) -> Result<Vec<u8>, &'static str> {
        let mouth = {
            let &(y, x) = self.snake.front().unwrap();
            let (dy, dx) = COORDS[self.direction.clone() as usize];
            ((y as i8 + dy) as u8, (x as i8 + dx) as u8)
        };

        if mouth.0 >= 32 || mouth.1 >= 32 {
            return Err("Game Over");
        }

        let mouth_idx = mouth.0 as u16 * 32 + mouth.1 as u16;
        if self.snake_set.contains(&mouth_idx) {
            return Err("Game Over");
        }

        self.snake.push_front(mouth);
        self.snake_set.insert(mouth_idx);

        if mouth != self.food {
            let tail = self.snake.pop_back().unwrap();
            Self::paint_pixel(&mut self.field, &tail, 0);
            true == self.snake_set.remove(&(tail.0 as u16 * 32 + tail.1 as u16));
        } else {
            self.food = Self::food_location(&self.snake_set);
        }

        Ok(self.current_frame())
    }

    fn paint(&mut self) {
        for pixel in self.snake.iter() {
            Self::paint_pixel(&mut self.field, pixel, 1);
        }

        Self::paint_pixel(&mut self.field, &self.food, 2);
    }

    fn paint_pixel(field: &mut [Vec<u8>], &(x, y): &(u8, u8), value: u8) {
        for i in 0..4 {
            for j in 0..4 {
                field[x as usize * 4 + i][y as usize * 4 + j] = value;
            }
        }
    }

    fn food_location(snake: &HashSet<u16>) -> (u8, u8) {
        let blanks: Vec<u16> = (0..1024).filter(|i| !snake.contains(i)).collect();
        let mut rng = thread_rng();
        let location = rng.choose(&blanks).unwrap();
        ((location / 32) as u8, (location % 32) as u8)
    }
}
