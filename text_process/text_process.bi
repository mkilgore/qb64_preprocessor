DIM SHARED SIZEOF_MACRO, SIZEOF_DEFINE

SIZEOF_MACRO = MEM_SIZEOF_MEM_STRING + 4 + MEM_SIZEOF_MEM_ARRAY
TYPE macro
  fnam AS MEM_String
  subfunc AS LONG '1 for SUB, 2 for FUNC
  lines as MEM_Array
END TYPE

SIZEOF_DEFINE = MEM_SIZEOF_MEM_STRING + MEM_SIZEOF_MEM_STRING
TYPE define
  nam AS MEM_String
  value as MEM_String
END TYPE

DIM SHARED PRE_FILE$, PRE_LINE AS LONG, PRE_recurse AS LONG
