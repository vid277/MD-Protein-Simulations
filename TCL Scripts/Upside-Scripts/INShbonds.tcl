
set molname [molinfo top get name]
set numframes [molinfo top get numframes]

puts "$traj IDE-Ins Hbonds for $numframes frames"
for {set frame 0} {${frame} < ${numframes}} {incr frame} {

	hbonds -sel1 $IDEall -sel2 $insAll -writefile no -frames $frame:$frame -plot no -writefile yes -type all -outfile $traj-$frame-InsIDEhbonds_$rep.dat -detailout $traj-$frame-InsIDEhbonds_detail_$rep.dat 

	puts "Hbonds details for $traj: $frame of $numframes"

}



