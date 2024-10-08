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

/// test Int::land
test "Int::land should perform bitwise AND operation" {
  let a = 0b101
  let b = 0b011
  inspect!(a.land(b), content="1")
  inspect!((0xffff_ffff).land(0xa000_0000) == 0xa000_0000, content="true")
  inspect!((0xffff_ffff).land(0x0) == 0, content="true")
  inspect!((0xffff_ffff).land(0xffff_ffff) == 0xffff_ffff, content="true")
}

/// test Int::lor
test "Int::lor should perform bitwise OR operation" {
  inspect!((0b101).lor(0b011) == 0b111, content="true")
  inspect!((0xffff_ffff).lor(0xa000_0000) == 0xffff_ffff, content="true")
  inspect!((0xffff_ffff).lor(0x0) == 0xffff_ffff, content="true")
  inspect!((0xffff_ffff).lor(0xffff_ffff) == 0xffff_ffff, content="true")
}

/// test Int::lxor
test "Int::lxor should perform bitwise XOR operation" {
  inspect!((0b101).lxor(0b011) == 0b110, content="true")
  inspect!((0xffff_ffff).lxor(0xa000_0000) == 0x5fff_ffff, content="true")
  inspect!((0xffff_ffff).lxor(0x0) == 0xffff_ffff, content="true")
  inspect!((0xffff_ffff).lxor(0xffff_ffff) == 0, content="true")
}

/// test Int::lsl
test "Int::lsl should perform left shift operation" {
  inspect!((7).lsl(1), content="14")
  inspect!((0b101).lsl(1) == 0b1010, content="true")
  inspect!((0xffff_ffff).lsl(1) == 0xffff_fffe, content="true")
  inspect!((0xffff_ffff).lsl(0) == 0xffff_ffff, content="true")
  inspect!((0xffff_ffff).lsl(3), content="-8")
  let arr = Array::make(33, 0).mapi(fn { i, _ => i })
  inspect!(
    arr,
    content="[0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32]",
  )
  let r = arr.map(fn { i => (0xffff_ffff).lsl(i) })
  // note when shifting 32 bits or more, it returns the original value
  inspect!(
    r,
    content="[-1, -2, -4, -8, -16, -32, -64, -128, -256, -512, -1024, -2048, -4096, -8192, -16384, -32768, -65536, -131072, -262144, -524288, -1048576, -2097152, -4194304, -8388608, -16777216, -33554432, -67108864, -134217728, -268435456, -536870912, -1073741824, -2147483648, -1]",
  )
  inspect!((7).lsl(32), content="7")
}

test "reinterpret: UInt <-> Int" {
  inspect!(0U.reinterpret_as_int(), content="0")
  inspect!(1U.reinterpret_as_int(), content="1")
  inspect!((0x7fff_ffff : UInt).reinterpret_as_int(), content="2147483647")
  inspect!((0x7fff_ffff : UInt), content="2147483647")
  inspect!((0x8000_0000 : UInt).reinterpret_as_int(), content="-2147483648")
  inspect!((0x8000_0000 : UInt), content="2147483648")
  inspect!((0xffff_ffff : UInt).reinterpret_as_int(), content="-1")
  inspect!((0xffff_ffff : UInt), content="4294967295")
  inspect!((0).reinterpret_as_uint(), content="0")
  inspect!((1).reinterpret_as_uint(), content="1")
  inspect!((2147483647).reinterpret_as_uint(), content="2147483647")
  inspect!((-2147483648).reinterpret_as_uint(), content="2147483648")
  inspect!((-1).reinterpret_as_uint(), content="4294967295")
}

test "uint test" {
  inspect!(100U == 100U, content="true")
  inspect!(0U < 100U, content="true")
  inspect!(100U > 0U, content="true")
  inspect!(2147483648U.reinterpret_as_int(), content="-2147483648")
  inspect!((-2147483648).reinterpret_as_uint(), content="2147483648")
  inspect!((2147483648U + 1000000000U).to_uint64(), content="3147483648")
  inspect!(2147483647U + 1U, content="2147483648")
  inspect!(0U - 1U, content="4294967295")
  inspect!(2147483647U * 2U, content="4294967294")
  inspect!(0x80000000U / 2U, content="1073741824")
  inspect!(4294967295U % 17U, content="0")
  inspect!(0xFFFFFFFFU.land(0xFFFFU), content="65535")
  inspect!(0xFF00U.lor(0xFFU), content="65535")
  inspect!(0xFFFF00U.lxor(0xFF00FFU), content="65535")
  inspect!(0x1U.lsl(31), content="2147483648")
  inspect!(2147483648U.lsr(31), content="1")
}

test "uint64 test" {
  inspect!(100UL == 100UL, content="true")
  inspect!(0UL < 100UL, content="true")
  inspect!(100UL > 0UL, content="true")
  inspect!(9223372036854775808UL.to_int64(), content="-9223372036854775808")
  inspect!((-9223372036854775808L).to_uint64(), content="9223372036854775808")
  inspect!((9223372036854775808UL + 1UL).to_uint(), content="1")
  inspect!((9223372036854775808UL + 1UL).to_int(), content="1")
  inspect!(9223372036854775808UL + 1UL, content="9223372036854775809")
  inspect!(0UL - 1UL, content="18446744073709551615")
  inspect!(9223372036854775808UL * 2UL, content="0")
  inspect!(0x8000000000000000UL / 2UL, content="4611686018427387904")
  inspect!(18446744073709551615UL % 17UL, content="0")
  inspect!(0xFFFFFFFFUL.land(0xFFFFUL), content="65535")
  inspect!(0xFF00UL.lor(0xFFUL), content="65535")
  inspect!(0xFFFF00UL.lxor(0xFF00FFUL), content="65535")
  inspect!(0x1UL.lsl(63), content="9223372036854775808")
  inspect!(9223372036854775808UL.lsr(63), content="1")
}

test "from double to" {
  inspect!(10.0.reinterpret_as_i64(), content="4621819117588971520")
  inspect!(10.0.reinterpret_as_u64(), content="4621819117588971520")
  inspect!(20.0.reinterpret_as_i64(), content="4626322717216342016")
  inspect!(20.0.reinterpret_as_u64(), content="4626322717216342016")
}

test "u64 to double" {
  inspect!(10UL.to_double(), content="10")
  inspect!(20UL.to_double(), content="20")
  inspect!(0UL.to_double(), content="0")
  inspect!(10L.to_double(), content="10")
  inspect!(20L.to_double(), content="20")
  inspect!(0L.to_double(), content="0")
  inspect!(18446744073709551615UL.to_double(), content="18446744073709552000")
  inspect!(8446744073709551615UL.to_double(), content="8446744073709552000")
  inspect!(8446744073709551615L.to_double(), content="8446744073709552000")
  inspect!(-8446744073709551615L.to_double(), content="-8446744073709552000")
  inspect!(844674400955615UL.to_double(), content="844674400955615")
  inspect!(844674400955615L.to_double(), content="844674400955615")
  inspect!(-844674400955615L.to_double(), content="-844674400955615")
}

test "UInt64::lnot test cases" {
  // Test case 1: Boundary case, testing the behavior with the maximum value of UInt64
  inspect!(UInt64::lnot(@uint64.max_value), content="0")

  // Test case 2: Boundary case, testing the behavior with the minimum value of UInt64
  inspect!(UInt64::lnot(@uint64.min_value), content="18446744073709551615")

  // Test case 3: Random case, testing with a random large value
  inspect!(UInt64::lnot(12345678901234567890UL), content="6101065172474983725")

  // Test case 4: Random case, testing with a random small value
  inspect!(UInt64::lnot(42UL), content="18446744073709551573")

  // Test case 5: Random case, testing with a value that has 1s in some bits
  inspect!(UInt64::lnot(0xAAAAAAAAAAAAAAAAUL), content="6148914691236517205")

  // Test case 6: Random case, testing with a value that has 0s in some bits
  inspect!(UInt64::lnot(0x5555555555555555UL), content="12297829382473034410")

  // Test case 7: Random case, testing with a value that has a mix of 1s and 0s
  inspect!(UInt64::lnot(0x123456789ABCDEF0UL), content="17134975606245761295")

  // Test case 8: Random case, testing with a value that has all 1s
  inspect!(UInt64::lnot(0xFFFFFFFFFFFFFFFFUL), content="0")
}

test "shift" {
  inspect!(1 << 2, content="4")
  inspect!(1UL << 2, content="4")
  // right shift
  inspect!(4 >> 2, content="1")
  inspect!(4UL >> 2, content="1")
  inspect!(2 >> 2, content="0")
  inspect!(-2 >> 2, content="-1")
  inspect!(2UL >> 2, content="0")
}

test "float" {
  fn f(x : Float) -> Float {
    x
  }

  inspect!(f(5.3) == 2.0, content="false")
  inspect!(f(5.3) + 2.0 == 7.3, content="true")
  inspect!((f(3.14) + 2.17).to_double(), content="5.310000419616699")
  inspect!((f(5.3) - 2.0).to_double(), content="3.3000001907348633")
  inspect!((f(2.0) - 5.3).to_double(), content="-3.3000001907348633")
  inspect!((f(5.3) - 5.3).to_double(), content="0")
  inspect!((f(5.3) * 2.0).to_double(), content="10.600000381469727")
  inspect!((f(-5.3) * 2.0).to_double(), content="-10.600000381469727")
  inspect!((f(-5.3) * -2.0).to_double(), content="10.600000381469727")
  inspect!((f(5.3) * -2.0).to_double(), content="-10.600000381469727")
  inspect!((f(5.3) / 2.0).to_double(), content="2.6500000953674316")
  inspect!((f(2.0) / 5.3).to_double(), content="0.37735846638679504")
  inspect!((f(2.12345) / 2.12345).to_double(), content="1")
  inspect!((f(2.12345) / -2.12345).to_double(), content="-1")
  inspect!((f(0) / 2.12345).to_double(), content="0")
  inspect!((3.6 : Float) != 0.6, content="true")
  inspect!((3.6 : Float).compare(0.6), content="1")
  inspect!((0.3 : Float).compare(0.6), content="-1")
  inspect!((0.3 : Float).compare(-0.6), content="1")
  inspect!((-0.3 : Float).compare(-0.6), content="1")
  inspect!((0.3 : Float).to_double() == 0.3, content="false")
  inspect!((0.3 : Float).reinterpret_as_int(), content="1050253722")
  inspect!(b'5'.to_float().to_double(), content="53")
  inspect!((123456).to_float().to_double(), content="123456")
  // inspect!((0.36 : Float).sqrt().to_double(), content="0.6000000238418579")
}

test "Int::to_double" {
  inspect!((10).to_double(), content="10")
  inspect!((20).to_double(), content="20")
}
