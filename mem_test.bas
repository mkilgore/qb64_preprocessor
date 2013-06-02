'$include:'mem/mem.bi'

TYPE test_type
  l as LONG
  l2 as LONG
END TYPE

$CONSOLE
$SCREENHIDE 
DIM o as _OFFSET, m as _MEM, t as test_type

_DEST _CONSOLE

print "allocating"
o = MEM_MALLOC%&(20)
$CHECKING:OFF

t.l = 20

_MEMPUT m, o, t.l

t.l2 = 3926
print "reallocing"; o
o = MEM_REALLOC%&(o, t.l2)

PRINT _MEMGET(m, o, LONG)

PRINT o

SUB debug_output (s$)
if DEBUG then d& = _DEST: _DEST _CONSOLE: print s$: _DEST d&
END SUB

'$include:'mem/mem.bm'
