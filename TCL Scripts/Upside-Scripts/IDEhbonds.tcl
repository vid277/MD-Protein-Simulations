set molname [molinfo top get name]
set numframes [molinfo top get numframes]

puts "$traj IDEN-IDEC Hbonds for $numframes frames"
for {set frame 0} {${frame} < ${numframes}} {incr frame} {

        hbonds -sel1 $andomain -sel2 $acdomain -writefile no -frames $frame:$frame -plot no -writefile yes -type all -outfile $traj-$frame-A-IDEhbonds_$rep.dat -detailout $traj-$frame-A-IDEhbonds_detail_$rep.dat

	hbonds -sel1 $bndomain -sel2 $bcdomain -writefile no -frames $frame:$frame -plot no -writefile yes -type all -outfile $traj-$frame-B-IDEhbonds_$rep.dat -detailout $traj-$frame-B-IDEhbonds_detail_$rep.dat

        puts "Hbonds details for $traj: $frame of $numframes"

}


