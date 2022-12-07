set outfile [open "$traj-coords.txt" w+]

set molname [molinfo top get name]
puts $outfile "Mol	!	Frame	!	AD1-X	AD1-Y	AD1-Z	AD2-X	AD2-Y	AD2-Z	Alink-X	Alink-Y	Alink-Z	AD3-X	AD3-Y	AD3-Z	AD4-X	AD4-Y	AD4-Z	BD1-X	BD1-Y	BD1-Z	BD2-X	BD2-Y	BD2-Z	Blink-X	Blink-Y	Blink-Z	BD3-X	BD3-Y	BD3-Z	BD4-X	BD4-Y	BD4-Z	Azn-X	Azn-Y	Azn-Z	Bzn-X	Bzn-Y	Bzn-Z	insAYQ-X	insAYQ-Y	insAYQ-Z	insBHL-X	insBHL-Y	insBHL-Z"

set numframes [molinfo top get numframes]
puts "Coords for $numframes frames"
for {set frame 0} {${frame} < ${numframes}} {incr frame} {

	$ad1 frame $frame
	set ad1_com [measure center ${ad1} weight mass]
	$ad2 frame $frame
	set ad2_com [measure center ${ad2} weight mass]
	$alink frame $frame
	set alink_com [measure center ${alink} weight mass]
	$ad3 frame $frame
	set ad3_com [measure center ${ad3} weight mass]
	$ad4 frame $frame
	set ad4_com [measure center ${ad4} weight mass]
		
	$bd1 frame $frame
	set bd1_com [measure center ${bd1} weight mass]
	$bd2 frame $frame
	set bd2_com [measure center ${bd2} weight mass]
	$blink frame $frame
	set blink_com [measure center ${blink} weight mass]
	$bd3 frame $frame
	set bd3_com [measure center ${bd3} weight mass]
	$bd4 frame $frame
	set bd4_com [measure center ${bd4} weight mass]

	$AznCoord frame $frame
	set Azn_com [measure center ${AznCoord} ]
	$BznCoord frame $frame
	set Bzn_com [measure center ${BznCoord} ]

	$insAYQ frame $frame
	set insAYQ_com [measure center ${insAYQ} weight mass]
	$insBHL frame $frame
	set insBHL_com [measure center ${insBHL} weight mass]


	puts $outfile "$molname	! $frame ! $ad1_com $ad2_com $alink_com $ad3_com $ad4_com $bd1_com $bd2_com $blink_com $bd3_com $bd4_com $Azn_com $Bzn_com $insAYQ_com $insBHL_com"

	puts "Coords $traj: $frame of $numframes"
}

close $outfile
