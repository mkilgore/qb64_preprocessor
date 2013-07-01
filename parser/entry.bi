
TYPE statement_entry
  node_size   as LONG

  ' Commands marked as 'OTHER' are handled internaly because of their syntax
  ' Commands like PRINT are like this
  cmd_type    as _byte '0 -- SUB type of command, 1 -- FUNC, 2 -- OTHER
  ident       as MEM_String
  params      as MEM_String 'A bunch of _INTEGER64's via _MK$(), in same order as format
  return_type as _INTEGER64
  format      as MEM_String

  call_name   as mem_string
END TYPE

REDIM parse_commands(20) as parse_statement_entry, parse_command_count as long

