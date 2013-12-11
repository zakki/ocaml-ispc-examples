open Ctypes
open PosixTypes
open Foreign

let s = foreign "simple"
  (ptr float @-> ptr float @-> int32_t @-> returning void)

let simple' vin vout count =
  let vin' = Array.start vin in
  let vout' = Array.start vout in
  let count' = Int32.of_int count in
  s vin' vout' count'

let _ =
  (* Initialize input buffer *)
  let vin = Array.make float 16 in
  for i = 0 to 15 do
    Array.set vin i (float_of_int i)
  done;
  let vout = Array.make float 16 in

  (* Call simple() function from simple.ispc file *)
  simple' vin vout 16;

  (* Print results *)
  for i = 0 to 15 do
    Printf.printf "%d: simple(%f) = %f\n" i
      (Array.get vin i)
      (Array.get vout i);
  done;
  ()
