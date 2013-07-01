
CONST PARSE_IS_ASSIGNMENT = 1
CONST PARSE_IS_SUB        = 2
CONST PARSE_IS_FUNCTION   = 4
CONST PARSE_IS_OTHER      = 8

TYPE statement_base
  statement_type AS _INTEGER64
  flags          as _INTEGER64
  leafs          as MEM_Array
END TYPE

TYPE QB64_Source
  nodes     as long 
  base_node as _OFFSET
END TYPE

