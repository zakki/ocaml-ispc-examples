module C = Ctypes
open PosixTypes
open Foreign

external reset_and_start_timer: unit -> unit = "caml_reset_and_start_timer"
external get_elapsed_mcycles: unit -> float = "caml_get_elapsed_mcycles"

let s =
  let open Ctypes in
  foreign "sort_ispc"
  (int32_t @-> ptr uint32_t @-> ptr uint32_t @-> int32_t @-> returning void)

let sort_ispc' n code order ntasks =
  let n' = Int32.of_int n in
  let code' = C.Array.start code in
  let order' = C.Array.start order in
  let ntasks' = Int32.of_int ntasks in
  s n' code' order' ntasks'

let rand_max = 0x3fffffff

let _ =
  let n = if Array.length Sys.argv == 1
    then 1000000
    else int_of_string Sys.argv.(1) in
  let m = if n < 100 then 1 else 50 in
  let l = if n < 100 then n else rand_max in
  let tISPC1 = ref 0.0 in
  let tISPC2 = ref 0.0 in
  let tSerial = ref 0.0 in
  let code = C.Array.make C.uint32_t n in
  let order = C.Array.make C.uint32_t n in

  Random.init 0;

  for i = 0 to m - 1 do begin
    for j = 0 to n - 1 do
      C.Array.set code j (Unsigned.UInt32.of_int (Random.int l))
    done;
    reset_and_start_timer();

    sort_ispc' n code order 1;

    tISPC1 := !tISPC1 +. get_elapsed_mcycles();
  end done;

  Printf.printf "[sort ispc]:\t[%.3f] million cycles\n" !tISPC1;

  Random.init 0;

  for i = 0 to m - 1 do begin
    for j = 0 to n - 1 do
      C.Array.set code j (Unsigned.UInt32.of_int (Random.int l))
    done;
    reset_and_start_timer();

    sort_ispc' n code order 0;

    tISPC2 := !tISPC2 +. get_elapsed_mcycles();
  end done;

  Printf.printf "[sort ispc + tasks]:\t[%.3f] million cycles\n" !tISPC2;

  Random.init 0;

  let code = Array.make n 0 in

  for i = 0 to m - 1 do begin
    for j = 0 to n - 1 do
      Array.set code j (Random.int l)
    done;
    reset_and_start_timer();

    Array.sort (fun a b -> a - b) code;

    tSerial := !tSerial +. get_elapsed_mcycles();
  end done;

  Printf.printf "[sort serial]:\t\t[%.3f] million cycles\n" !tSerial;

  Printf.printf "\t\t\t\t(%.2fx speedup from ISPC, %.2fx speedup from ISPC + tasks)\n" (!tSerial /. !tISPC1) (!tSerial /. !tISPC2);

  ()
