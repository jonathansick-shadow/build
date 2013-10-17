#############################################################################################################
# .gdbinit file
#
# Mostly copied from Robert Lupton, 30 Jan 2006
#############################################################################################################

#############################################################################################################
# Setups
#############################################################################################################

# Tell the environment that we're in gdb
set environment GDB 1

#set confirm off
#set heuristic-fence-post 10000
#show follow-fork-mode
set history save
set history size 1000
set print null-stop
set print pretty on
set print symbol-filename on

def consts
	set $pi=3.141592654
	set $SH_SUCCESS = 0x8001c009
	set $SH_GENERIC_ERROR = 16384
end
document consts
	Set various interesting values.
	Gdb clears them everytime it loads an image, as it thinks that the meaning
	of "float" or "int" may have changed
end

# Often finds what we need, and does no harm
dir src

# Allow loading, e.g., /home/astro/hsc/products-20130212/Linux64/gcc/4.6.3/lib64/libstdc++.so.6.0.16-gdb.py
set auto-load safe-path /

#############################################################################################################
# Macros --- making life simple
#############################################################################################################

define bell
	printf "\a"
end
document bell
        Ring the bell
end

define cc
	signal 2
end
document cc
	Send CTRL-C signal
end

define dl
	delete $bpnum  
	printf "Deleting breakpoint %d\n", $bpnum--
end
document dl
	Delete the most recent breakpoint
end

define f0
	frame 0
	list
end
document f0
	List frame 0
end

define ni
	nexti
	x/i $pc
end
document ni
	Go to next instruction, and print it
end

define si
	stepi
	x/i $pc
end
document si
	Step to next instruction, and print it
end

define pdeg
	print ($arg0)*180/3.1415926536
end
document pdeg
	Print a value given in radians in degrees
end

define pdeg2
	output ($arg0)*180/3.1415926536
	printf " "
	output ($arg1)*180/3.1415926536
	printf "\n"
end
document pdeg2
	Print two numbers, converting from radians to degrees
end

define p2
	output $arg0
	printf " "
	output $arg1
	printf "\n"
end
document p2
	Print two numbers
end

define p3
	output $arg0
	printf " "
	output $arg1
	printf " "
	output $arg2
	printf "\n"
end
document p3
	Print three numbers
end

define p4
	output $arg0
	printf " "
	output $arg1
	printf " "
	output $arg2
	printf " "
	output $arg3
	printf "\n"
end
document p4
	Print four numbers
end

def pp
	set print pretty on
	print $arg0
	set print pretty off
end
document pp
	Print an expression with pretty print on
end

define ret
	return
	continue
end

define rr
	dont-repeat
	run
end
document rr
	Run with no confirmation required
end

def rn
	run null -
end
document rn
	Run with null arguments
end

define w
	where 7
	echo \t...\n
end
document w
	Where am I?  Print a backtrace of 7 lines max
end


#############################################################################################################
# Loops
#############################################################################################################

define loop
   set $i=$arg0
   while $i < $arg1
      output $i
      echo \t		
      $arg2 $arg3
      set $i++		
   end
end
document loop
    Repeat the command "$arg2 $arg3" for $i = $arg0 .. $arg1-1

\    e.g.
\	loop 0 5 p objc->color[$i]->id
\	loop 0 5 ppeak objc->color[$i]->peaks->peak[0]
\
\	if foo is:
\           follow2 $arg0 ->next 10 ppeak
\
\	loop 0 5 foo objc->color[$i]->peaks->peak
\
See also sloop, which doesn't print the loop counter
end

define loop2
   set $i=$arg0
   while $i < $arg1
      output $i
      echo \t		
      $arg2 $arg3 $arg4
      set $i++		
   end
end
document loop2
    Repeat the command "$arg2 $arg3 $arg4" for $i = $arg0 .. $arg1-1
    See also sloop2, which doesn't print the loop counter
end

define loop3
   set $i=$arg0
   while $i < $arg1
      output $i
      echo \t		
      $arg2 $arg3 $arg4 $arg5
      set $i++		
   end
end
document loop3
	Repeat the command "$arg2 $arg3 $arg4 $arg5" for $i = $arg0 .. $arg1-1
end

define sloop
   set $i=$arg0
   while $i < $arg1
      $arg2 $arg3
      set $i++		
   end
end
document sloop
	Identical to loop, but don't print the loop counter
end

define sloop2
   set $i=$arg0
   while $i < $arg1
      $arg2 $arg3 $arg4
      set $i++		
   end
end
document sloop2
	Like loop2, but don't print the loop counter
end

define sloop3
   set $i=$arg0
   while $i < $arg1
      $arg2 $arg3 $arg4 $arg5
      set $i++		
   end
end
document sloop3
	Like loop3, but don't print the loop counter
end

define iloop
   set $i_i=$arg0
   while $i_i < $arg1
      output $i_i
      echo \t		
      $arg2 $arg3
      set $i_i++		
   end
end
document iloop
	Identical to loop (except that the variable's called $i_i),
	but used internally in e.g. pmask
end

define follow
   set $follow = 0
   set $next = $arg0
   while $follow < $arg2 && $next != 0
      output $follow
      echo \t		
      output ($next $arg3)
      echo \n		
      set $follow++
      set $next = $next $arg1
   end
end
document follow
	Follow a chain of $arg1 pointers from $arg0, until they reach a NULL
	(max: $arg2 elements). For each element "ptr", execute
		output ptr $arg3
	E.g.
		follow peaks->peaks ->next 10 ->colc
		follow peaks->peaks ->next 10 [0]
	where the latter prints the entire element. See also follow2 to apply
	a specified command to each element.
end

define follow2
   set $follow = 0
   set $next = $arg0
   while $follow < $arg2 && $next != 0
      output $follow
      echo \t		
      $arg3 $next

      set $follow++
      set $next = $next $arg1
   end
end
document follow2
	Follow a chain of $arg1 pointers from $arg0, until they reach a NULL
	(max: $arg2 elements). For each element "ptr", execute
		$arg3 ptr

	E.g.
		follow2 peaks->peaks ->next 10 ppeak
	to print the centres of a set of peaks.
	See also follow to print a given element
end

define sum
   set $iSAVED=$i
   set $i=$arg0
   set $sum = 0
   while $i < $arg1
      set $sum += $arg2
      set $i++		
   end
   set $i=$iSAVED
   output $sum
   printf "\n"
end
document sum
    Evaluate sum_{$i = $arg0}^{$i = $arg1-1} $arg2

    e.g. sum 0 10 foo[$i].n			
end

##############################################################################################################
# Electric fence
##############################################################################################################

define efence
  set environment EF_PROTECT_BELOW 0
  set environment LD_PRELOAD $arg0
  echo Enabled Electric Fence\n
end
document efence
  Enable memory allocation debugging through Electric Fence (efence(3)).
  Provide path to efence shared library as argument.
  See also nofence and underfence.
end
define underfence
  set environment EF_PROTECT_BELOW 1
  set environment LD_PRELOAD $arg0
  echo Enabled Electric Fence for undeflow detection\n
end
document underfence
  Enable memory allocation debugging for underflows through Electric Fence (efence(3)).
  Provide path to efence shared library as argument.
  See also nofence and underfence.
end
define nofence
  unset environment LD_PRELOAD
  echo Disabled Electric Fence\n
end
document nofence
  Disable memory allocation debugging through Electric Fence (efence(3)).
end

#############################################################################################################
# Extra stuff
#############################################################################################################


source ~/.gdbinit-lsst
source ~/.gdbinit-stl
source ~/.gdbinit-python
