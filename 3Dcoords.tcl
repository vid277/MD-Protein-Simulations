set outfile [open "$molecule-coords.txt" w+]

set molname [molinfo top get name]

puts $outfile "Mol	|	Frame	|	D1a.X	D1a.Y	D1a.Z	|	D1b.X	D1b.Y	D1b.Z	|	D2.X	D2.Y	D2.Z	|	S1.X	S1.Y	S1.Z	|	S2.X	S2.Y	S2.Z	| 	 S3.X	S3.Y	S3.Z	|	S4.X	S4.Y	S4.Z	|	Zn.X	Zn.Y	Zn.Z"

set numframes [molinfo top get numframes]

puts "Processing Coords for $numframes frames"

for {set frame 0} {${frame} < ${numframes}} {incr frame} {

	$D1a frame $frame
	    set D1a_comp [measure center ${D1a} weight mass]

	$D1b frame $frame
	    set D1b_comp [measure center ${D1b} weight mass]
	
    $D2 frame $frame
	    set D2_comp [measure center ${D2} weight mass]
	
    $S1 frame $frame
	    set S1_comp [measure center ${S1} weight mass]
	
    $S2 frame $frame
	    set S2_comp [measure center ${S2} weight mass]

    $S3 frame $frame
	    set S3_comp [measure center ${S3} weight mass]

	$S4 frame $frame
	    set S4_comp [measure center ${S4} weight mass]

	$Zinc frame $frame
		set Zn_comp [measure center ${Zinc} weight mass]

	puts $outfile "$molname	!	$frame	!	$D1a_comp	!	$D1b_comp	!	$D2_comp	!	$S1_comp	!	$S2_comp	!	$S3_comp	!	$S4_comp	!	$Zn_comp"

	puts "Coords $molecule: $frame of $numframes"
}

close $outfile