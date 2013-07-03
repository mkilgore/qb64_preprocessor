
CONST DEBUG = -1

$SCREENHIDE
$CONSOLE

CONST PRE_PROCESS_VERSION$ = ".10"

DECLARE LIBRARY "unistd"
  SUB getcwd(s as STRING, BYVAL l as LONG)
END DECLARE

'$include:'mem/mem.bi'
'$include:'cmd_args/parse_args.bi'
'$include:'parser/parser.bi'
'$include:'objects/objects.bi'
'$include:'at_commands/at_commands.bi'
'$include:'text_process/text_process.bi'

' Program globals 
DIM SHARED SOURCE_FILE$, SOURCE_DIRECTORY$
DIM SHARED QB64_DIRECTORY$
DIM SHARED OUTPUT_FILE$, OUTPUT_DIRECTORY$
DIM SHARED OS_SLASH$, OS AS LONG, OS_BITS AS LONG
CONST LNX = 1
CONST WIN = 2
CONST MAC = 3
CONST BIT_64 = 1
CONST BIT_32 = 2

DIM SHARED error_hand

DIM orig_source AS SOURCE_Copy
DIM source AS MEM_Array

ON ERROR GOTO error_handle

' Parse command line options
init COMMAND$, orig_source

_DEST _CONSOLE

'PRINT "SOURCE:"; SOURCE_FILE$

if SOURCE_FILE$ = "" then SOURCE_FILE$ = file_selection_GUI$

CHDIR SOURCE_DIRECTORY$
pre_process SOURCE_FILE$, source
CHDIR QB64_DIRECTORY$

'Quick handling of function pointers
for x = 1 to source.length
  n$ = MEM_get_Str_array$(source, x)
  n$ = replace_with_case$(n$, "@PROC", "_OFFSET")
  MEM_put_str_array source, x, n$
next x

parse_init_parser

parse_load_source source, orig_source

'handle_objects orig_source

'handle_at_commands orig_source

FOR x = 1 to source.last_element
  PRINT MEM_get_str_array$(source, x)
NEXT x

SYSTEM



error_handle:
error_hand = ERR
RESUME NEXT

SUB init (c$, src AS SOURCE_Copy)
  'debug_output "Initing..."
  IF INSTR(_OS$, "[WINDOWS]") THEN
    OS_slash$ = "\"
    OS = WIN
  ELSEIF INSTR(_OS$, "[MACOSX]") THEN
    OS_slash$ = "/"
    OS = MAC
  ELSEIF INSTR(_OS$, "[LINUX]") THEN
    OS_slash$ = "/"
    OS = LNX
  END IF
  if instr(_os$, "[32BIT]") then
    os_bits = bit_32
  else
    os_bits = bit_64
  end if
  'debug_output "Getting directory"
  QB64_DIRECTORY$ = SPACE$(1024)
  getcwd QB64_DIRECTORY$, LEN(QB64_DIRECTORY$)
  QB64_DIRECTORY$ = add_slash$(QB64_DIRECTORY$)
  'debug_output "Directory: " + QB64_DIRECTORY$

  init_source src

  SOURCE_FILE$ = get_file$(c$)
  SOURCE_DIRECTORY$ = add_slash$(get_dir$(c$))

  if LEFT$(SOURCE_DIRECTORY$, 1) <> "/" then
    SOURCE_DIRECTORY$ = QB64_DIRECTORY$ + SOURCE_DIRECTORY$
  end if

  'debug_output "File: " + SOURCE_FILE$
  'debug_output "Dir : " + SOURCE_DIRECTORY$

  if OS = WIN then SOURCE_FILE$ = UCASE$(SOURCE_FILE$): SOURCE_DIRECTORY$ = UCASE$(SOURCE_DIRECTORY$)
END SUB

FUNCTION file_selection_GUI$ ()
  INPUT "Source code file to preprocess:"; fil$
  file_selection_GUI$ = fil$


END FUNCTION

' General purpose functions

FUNCTION get_dir$ (f$)
  split_file_name f$, di$, fi$
  get_dir$ = di$
END FUNCTION

FUNCTION get_file$ (f$)
  split_file_name f$, di$, fi$
  get_file$ = fi$
END FUNCTION

SUB split_file_name (f$, di$, fi$)
  di$ = ""
  fi$ = f$
  DO
    di$ = di$ + left$(fi$, instr(fi$, OS_slash$))
    fi$ = mid$(fi$, instr(fi$, OS_slash$) + 1)
  LOOP until instr(fi$, OS_slash$) = 0
END SUB

FUNCTION add_slash$ (d$)
  if right$(d$, 1) <> OS_SLASH$ and len(d$) > 0 then
    add_slash$ = d$ + OS_SLASH$
  else
    add_slash$ = d$
  end if
END FUNCTION

FUNCTION string_not_in_array (s$, a as MEM_Array)
  FOR x = 1 to a.length
    'print "S:"; s$; " Arr:"; MEM_get_str_array$(a, x)
    if MEM_get_str_array$(a, x) = s$ then
      exit function
    end if
  NEXT x
  string_not_in_array = -1
END FUNCTION

FUNCTION strip_indent$ (n$)
  n$ = LTRIM$(n$)
END FUNCTION

FUNCTION undo_null_term$ (n$)
  if instr(n$, CHR$(0)) then
    undo_null_term$ = mid$(n$, 1, instr(n$, CHR$(0)) - 1)
  else
    undo_null_term$ = n$
  end if
END FUNCTION

FUNCTION get_cwd$ ()
if OS = LNX or OS = MAC then
  n$ = SPACE$(1024)
  getcwd n$, LEN(n$)
  get_cwd$ = add_slash$(undo_null_term$(n$))
end if
END FUNCTION

FUNCTION replace$(s$, r$, n$)
  e$ = s$
  do while instr(e$, r$)
    e$ = mid$(e$, 1, instr(e$, r$) - 1) + n$ + mid$(e$, instr(e$, r$) + 1)
  loop
  replace$ = e$
end function

FUNCTION replace_with_case$(s$, r$, r2$)
if instr(ucase$(s$), ucase$(r$)) then
  s2$ = s$
  do WHILE instr(ucase$(s2$), ucase$(r$))
    l = instr(ucase$(s$), ucase$(r$))
    s2$ = mid$(s$,1, l - 1) + r2$ + mid$(s$, l + len(r$))
  loop
  replace_with_case$ = s2$
else 
  replace_with_case$ = s$
end if
END FUNCTION

'Note -- Not guarenteed to work with malformed directory names
FUNCTION simplify_directory$ (directory$)
  d$ = directory$
  dont_add_next = 0
  if OS = WIN then
    if mid$(d$, 2, 1) = ":" then
      driv$ = mid$(d$, 1, 3)
      d$ = mid$(d$, 4)
    end if
  else
    if left$(d$, 1) = OS_slash$ then
      driv$ = OS_slash$
      d$ = mid$(d$, 2)
    end if
  end if
  do while instr(d$, OS_slash$)
    di$ = mid$(d$, 1, instr(d$, OS_slash$) - 1)
    'print "Di:"; di$
    if di$ = "." then dont_add_next = dont_add_next + 1
    if di$ = ".." and l$ > "" then 
      dont_add_next = dont_add_next + 1
      n$ = l$
      do
        n$ = mid$(n$, instr(n$, OS_slash$) + 1)
      loop until instr(n$, OS_slash$) = 0
      if n$ <> ".." then l$ = mid$(l$, 1, len(L$) - 1 - len(n$)) else dont_add_next = dont_add_next - 1
    end if
    if dont_add_next = 0 then
      if l$ > "" then l$ = l$ + OS_slash$
      l$ = l$ + di$
    else
      dont_add_next = dont_add_next - 1
    end if
    d$ = mid$(d$, instr(d$, OS_slash$) + 1)
  loop
  if right$(l$, 1) <> OS_slash$ then l$ = l$ + OS_slash$
  simplify_directory$ = driv$ + l$
END FUNCTION

SUB debug_output (s$)
if DEBUG then d& = _DEST: _DEST _CONSOLE: print s$: _DEST d&
END SUB

'$include:'cmd_args/parse_args.bm'
'$include:'text_process/text_process.bm'
'$include:'parser/parser.bm'
'$include:'objects/objects.bm'
'$include:'at_commands/at_commands.bm'
'$include:'mem/mem.bm'

