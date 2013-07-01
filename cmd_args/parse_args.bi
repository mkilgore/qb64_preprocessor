
const arg_param_type_num = 1
const arg_param_type_string = 2

TYPE ARG_ARGTYPE
  lng          as MEM_String
  short        as STRING * 1
  param_type   AS LONG
  param_value  as MEM_String
  param_is_set as _byte
END TYPE

REDIM SHARED arg_list(100) as arg_argtype, arg_nextreg AS LONG

