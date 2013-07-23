
DIM SHARED BYTE_TYPE AS _UNSIGNED LONG, INTEGER_TYPE AS _UNSIGNED LONG, LONG_TYPE AS _UNSIGNED LONG, SINGLE_TYPE AS _UNSIGNED LONG, DOUBLE_TYPE AS _UNSIGNED LONG, INTEGER64_TYPE AS _UNSIGNED LONG, STRING_TYPE AS _UNSIGNED LONG, OFFSET_TYPE AS _UNSIGNED LONG, FLOAT_TYPE AS _UNSIGNED LONG, SPECIAL_TYPE AS _UNSIGNED LONG, ARRAY_TYPE AS _UNSIGNED LONG 

BYTE_TYPE      = &H0001
INTEGER_TYPE   = &H0002
LONG_TYPE      = &H0004
SINGLE_TYPE    = &H0008
DOUBLE_TYPE    = &H0010
INTEGER64_TYPE = &H0020
STRING_TYPE    = &H0040
OFFSET_TYPE    = &H0080
FLOAT_TYPE     = &H0100
TYPE_NAME_TYPE = &H0200
SPECIAL_TYPE   = &H0400
UDT_TYPE       = &H0800

DIM SHARED IS_UNSIGNED AS _UNSIGNED LONG
IS_UNSIGNED = &H0001

DIM SHARED IS_NUMERAL AS _UNSIGNED LONG
IS_NUMERAL = BYTE_TYPE OR INTEGER_TYPE OR LONG_TYPE OR SINGLE_TYPE OR DOUBLE_TYPE OR INTEGER64_TYPE OR FLOAT_TYPE

TYPE type_info
  typ    as LONG
  flags  as long
  udt_n  as long
  length AS LONG
END TYPE

TYPE udt_leaf
  typ as type_info
  nam as MEM_String
END TYPE

TYPE udt_base
  nam         as MEM_String
  leaf_count  as long
  leafs       as _OFFSET
  size        as long
END TYPE

REDIM SHARED udt_list(100) as udt_base, udt_count as long

'$include:'ast.bi'
'$include:'entry.bi'

'$include:'in/qb64/lang.bi'
'$include:'out/qb64/lang.bi'
'$include:'out/cpp/lang.bi'


