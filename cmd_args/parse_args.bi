
const arg_param_type_num = 1
const arg_param_type_string = 2
const arg_param_type_integer = 3
const arg_param_type_integer_restrict = 4
const arg_param_Type_num_restrict = 5
TYPE ARG_ARGTYPE
  lng          as MEM_String
  short        as STRING * 1
  param_type   AS LONG
  max          as _float
  min          as _float
  param_value  as MEM_String
  param_is_set as _byte
END TYPE

REDIM SHARED arg_list(100) as arg_argtype, arg_nextreg AS LONG

