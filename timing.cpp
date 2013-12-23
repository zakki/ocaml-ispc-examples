#include "timing.h"
#include <caml/mlvalues.h>
#include <caml/memory.h>
#include <caml/alloc.h>

extern "C" {

CAMLprim value caml_reset_and_start_timer(value unit)
{
  CAMLparam1 (unit);
  reset_and_start_timer();
  CAMLreturn (Val_unit);
}

CAMLprim value caml_get_elapsed_mcycles(value unit)
{
  CAMLparam1 (unit);
  CAMLlocal1 (v);
  v = caml_copy_double(get_elapsed_mcycles());
  CAMLreturn (v);
}

}
