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

typealias TestX = Map[String, Int]

test {
  let u = { "x": 3, "y": 4 }
  let j = u.to_json()
  let h : TestX = @json.from_json!(j)
  inspect!(
    (j, h),
    content=
      #|(Object({"x": Number(3), "y": Number(4)}), {"x": 3, "y": 4})
    ,
  )
}

test {
  let u = Json::Array([Json::Number(1), Json::String("str")])
  let v : Result[Array[Int], _] = @json.from_json?(u)
  inspect!(
    v,
    content=
      #|Err(JsonDecodeError(($[1], "Int::from_json: expected number")))
    ,
  )
}

test {
  let u = Json::Object(
    {
      "x": Json::Object({ "xx": Json::Number(1) }),
      "y": Json::Object({ "yy": Json::String("str") }),
    },
  )
  let v : Result[Map[String, Map[String, Double]], _] = @json.from_json?(u)
  inspect!(
    v,
    content=
      #|Err(JsonDecodeError(($.y.yy, "Double::from_json: expected number")))
    ,
  )
}
