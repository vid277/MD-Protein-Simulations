set outfile [open "$traj-insSS.txt" w+]

puts $outfile "Mol	!	Frame	!	SecStr"

set numframes [molinfo top get numframes]
#set insulin [atomselect top "name CA and (chain C or chain D or chain E or chain F)"]
set molname [molinfo top get name]

for {set frame 0} {$frame < $numframes} {incr frame} {
	animate goto $frame
	mol ssrecalc top
	set secstr [$insCA get structure]
	puts $outfile "$molname ! $frame ! $secstr"
	puts "InsSS $traj: $frame of $numframes"		
}

puts "Mischief managed."
