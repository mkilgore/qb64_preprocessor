DIM SHARED SIZEOF_pre_MACRO

TYPE PRE_processor_cmd
  nam as MEM_String
  
END TYPE

SIZEOF_pre_MACRO = MEM_SIZEOF_MEM_STRING + 4 + MEM_SIZEOF_MEM_ARRAY
TYPE PRE_macro
  fnam AS MEM_String
  subfunc AS LONG '1 for SUB, 2 for FUNC
  lines as MEM_Array
END TYPE

DIM SHARED PRE_FILE$, PRE_LINE AS LONG, PRE_recurse AS LONG
dim shared pre_include_once_files AS MEM_Array
dim shared pre_macro_list AS MEM_Array

dim shared pre_run_preprocessor as long, pre_dont_run as long
dim shared pre_skip_include as long

'$include:'commands/define_cmd.bi'
'$include:'commands/if_cmd.bi'
'$include:'commands/include_cmd.bi'

'$include:'eval/eval.bi'

