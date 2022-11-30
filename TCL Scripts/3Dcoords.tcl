set outfile [open "$molecule-coords.txt" w+]

set molname [molinfo top get name]

puts $outfile "Mol	Frame	D1a.X	D1a.Y	D1a.Z	D1b.X	D1b.Y	D1b.Z	D2.X	D2.Y	D2.Z	S1.X	S1.Y	S1.Z	S2.X	S2.Y	S2.Z	S3.X	S3.Y	S3.Z	S4.X	S4.Y	S4.Z	Zn.X	Zn.Y	Zn.Z	S1S2.X	S1S2.Y	S1S2.Z	S1S3.X	S1S3.Y	S1S3.Z	S1S4.X	S1S4.Y	S1S4.Z	S2S3.X	S2S3.Y	S2S3.Z	S2S4.X	S2S4.Y	S2S4.Z	S3S4.X	S3S4.Y	S3S4.Z	S1S2S3S4.X	S1S2S3S4.Y	S1S2S3S4.Z	S1S2S3.X	S1S2S3.Y	S1S2S3.Z	S2S3S4.X	S2S3S4.Y	S2S3S4.Z	S2S3S4.X	S1S3S4.X	S1S3S4.Y	S1S3S4.Z	S1S2S4.X	S1S2S4.Y	S1S2S4.Z"

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

	$D1ab frame $frame
		set D1ab_comp [measure center ${D1ab} weight mass]
	
	$S1andS2 frame $frame
		set S1andS2_comp [measure center ${S1andS2} weight mass]
	
	$S1andS3 frame $frame
		set S1andS3_comp [measure center ${S1andS3} weight mass]
	
	$S1andS4 frame $frame
		set S1andS4_comp [measure center ${S1andS4} weight mass]
	
	$S2andS3 frame $frame
		set S2andS3_comp [measure center ${S2andS3} weight mass]

	$S2andS4 frame $frame
		set S2andS4_comp [measure center ${S2andS4} weight mass]
	
	$S3andS4 frame $frame
		set S3andS4_comp [measure center ${S3andS4} weight mass]

	$S1andS2andS3andS4 frame $frame
		set S1andS2andS3andS4_comp [measure center ${S1andS2andS3andS4} weight mass]
	
	$S1andS2andS3 frame $frame
		set S1andS2andS3_comp [measure center ${S1andS2andS3} weight mass]
	
	$S2andS3andS4 frame $frame
		set S2andS3andS4_comp [measure center ${S2andS3andS4} weight mass]

	$S1andS3andS4 frame $frame
		set S1andS3andS4_comp [measure center ${S1andS3andS4} weight mass]

	$S1andS2andS4 frame $frame
		set S1andS2andS4_comp [measure center ${S1andS2andS4} weight mass]

	puts $outfile "$molname!$frame!$D1a_comp!$D1b_comp!$D1ab_comp!$D2_comp!$S1_comp!$S2_comp!$S3_comp!$S4_comp!$Zn_comp!$S1andS2_comp!$S1andS3_comp!$S1andS4_comp!$S2andS3_comp!$S2andS4_comp!$S3andS4_comp!$S1andS2andS3andS4_comp!$S1andS2andS3_comp!$S2andS3andS4_comp!$S1andS3andS4_comp!$S1andS2andS4_comp"

	puts "Coords $molecule: $frame of $numframes"
}

close $outfile