dim shared SIZEOF_PRE_OPERATOR

SIZEOF_PRE_OPERATOR = MEM_SIZEOF_MEM_STRING + 4
TYPE PRE_operator
  nam       as MEM_String
  func      as LONG
  params    as long
  assoc     as _byte '-1 if left assosicative
  prec      as long 'Precedence
  leave_text as _byte '-1 if the inside should *NOT* be replaced with values from !!define's.
  func_flag as long 'If -1, then uses function syntax, like SIN()
END TYPE

REDIM SHARED PRE_OPS(20) AS pre_operator, PRE_op_count AS LONG

