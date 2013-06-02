
CONST DEBUG = -1

$SCREENHIDE
$CONSOLE

CONST PRE_PROCESS_VERSION$ = ".10"

DECLARE LIBRARY "unistd"
  SUB getcwd(s as STRING, BYVAL l as LONG)
END DECLARE

'$include:'mem/mem.bi'
'$include:'parser/parser.bi'
'$include:'objects/objects.bi'
'$include:'at_commands/at_commands.bi'
'$include:'text_process/text_process.bi'

' Program globals 
DIM SHARED SOURCE_FILE$, SOURCE_DIRECTORY$
DIM SHARED QB64_DIRECTORY$
DIM SHARED OS_SLASH$, OS AS LONG
CONST LNX = 1
CONST WIN = 2
CONST MAC = 3

DIM SHARED error_hand

DIM orig_source AS SOURCE_Copy
DIM source AS MEM_Array

ON ERROR GOTO error_handle

' Parse command line options
init COMMAND$, orig_source

_DEST _CONSOLE

PRINT "SOURCE:"; SOURCE_FILE$

if SOURCE_FILE$ = "" then SOURCE_FILE$ = file_selection_GUI$

CHDIR SOURCE_DIRECTORY$
pre_process SOURCE_FILE$, source
CHDIR QB64_DIRECTORY$

INPUT "Next:";xxx$

FOR x = 1 to source.last_element
  debug_output MEM_get_str_array$(source, x)
NEXT x

'load_source source, orig_source

'handle_objects orig_source

'handle_at_commands orig_source

SYSTEM



error_handle:
error_hand = ERR
RESUME NEXT

SUB init (c$, src AS SOURCE_Copy)
  debug_output "Initing..."
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
  debug_output "Getting directory"
  QB64_DIRECTORY$ = SPACE$(1024)
  getcwd QB64_DIRECTORY$, LEN(QB64_DIRECTORY$)
  QB64_DIRECTORY$ = add_slash$(QB64_DIRECTORY$)
  debug_output "Directory: " + QB64_DIRECTORY$

  init_source src

  SOURCE_FILE$ = get_file$(c$)
  SOURCE_DIRECTORY$ = add_slash$(get_dir$(c$))

  if LEFT$(SOURCE_DIRECTORY$, 1) <> "/" then
    SOURCE_DIRECTORY$ = QB64_DIRECTORY$ + SOURCE_DIRECTORY$
  end if

  debug_output "File: " + SOURCE_FILE$
  debug_output "Dir : " + SOURCE_DIRECTORY$

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

'Note -- Not guarenteed to work with malformed directory names
FUNCTION simplify_directory$ (directory$)
  d$ = directory$
  do while instr(d$, OS_slash$)
    l$ = l$ + mid$(d$, 1, instr(d$, OS_slash$))
    d$ = mid$(d$, instr(d$, OS_slash$) + 1)
    
  loop
END FUNCTION

SUB debug_output (s$)
if DEBUG then d& = _DEST: _DEST _CONSOLE: print s$: _DEST d&
END SUB

'$include:'text_process/text_process.bm'
'$include:'parser/parser.bm'
'$include:'objects/objects.bm'
'$include:'at_commands/at_commands.bm'
'$include:'mem/mem.bm'

