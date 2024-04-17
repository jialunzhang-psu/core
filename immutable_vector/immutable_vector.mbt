// Copyright 2024 International Digital Economy Academy
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

// This module implements the set data structure.
// The types stored in set need to implement the Compare trait.
// All operations over sets are purely applicative (no side-effects).

// # Constants that define the shape of the tree structure.
// # In production, BITS would likely be log_2(32) = 5, like that of Clojure's
// # Vector implemenetation.

// Hyperparameters for radix tree indexing usage, if you don't understand them, refer to 
// https://hypirion.com/musings/understanding-persistent-vector-pt-2
let bits : Int = 5
let width : Int = Int::lsl(1, bits)
let mask : Int = width - 1

fn Node::new[T](~children : Option[Node[T]] = None) -> Node[T] {
  let ret : Array[Option[T]] = Array::make(width, None)
  match children {
    Some(children) =>
      for i = 0; i < children.0.length(); i = i + 1 {
        ret[i] = children.0[i]
      }
    None => ()
  }
  Node(ret)
}

fn Node::copy[T](self : Node[T]) -> Node[T] {
  let ret : Array[Option[T]] = Array::make(width, None)
  for i = 0; i < self.0.length(); i = i + 1 {
    ret[i] = self.0[i]
  }
  Node(ret)
}

fn get_tree_depth(length : Int) -> Int {
  // TODO: math.log is not avaiable yet, use this stupid simple way for now
  // change the number according to the number of bits
  if length == 0 {
    0
  } else if length <= 32 { // 2^5 
    1
  } else if length <= 1024 { // 2^10
    2
  } else if length <= 32768 { // 2^15
    3
  } else if length <= 1048576 { // 2^20
    4
  } else if length <= 33554432 { // 2^25
    5
  } else if length <= 1073741824 { // 2^30
    6
  } else {
    7
  }
}