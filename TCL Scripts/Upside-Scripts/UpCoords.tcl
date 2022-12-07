set allvtfs [glob -directory "allVTFs" -- "*.vtf"]
set filenum 0
foreach v $allvtfs {
	mol load vtf $v
	incr filenum

	set molname [molinfo top get name]
	set num_steps [molinfo top get numframes]
	
	#Set the domains appropriately for each molecule
	if {[string match "00-*" $molname] || [string match "01-*" $molname] || [string match "08-*" $molname] || [string match "10-*" $molname] || [string match "11-*" $molname] || [string match "12-*" $molname] || [string match "15-*" $molname] || [string match "16-*" $molname] || [string match "17-*" $molname]|| [string match "18-*" $molname]|| [string match "19-*" $molname]|| [string match "21-*" $molname]|| [string match "22-*" $molname]|| [string match "23-*" $molname]  } {
		source ~/Scripts/UpSetSel/setOC1ins.tcl
		set substrate "Insulin"
	} elseif {[string match "02-*" $molname] || [string match "05-*" $molname]} {
		source ~/Scripts/UpSetSel/setOO1ins.tcl
		set substrate "Insulin"
	} elseif {[string match "04-*" $molname]} {
		source ~/Scripts/UpSetSel/setOO0ins.tcl
		set substrate "None"
	} elseif {[string match "20-*" $molname] } {
		source ~/Scripts/UpSetSel/setOpO0ins.tcl
		set substrate "None"
	} elseif {[string match "07-*" $molname] || [string match "09-*" $molname]} {
		source ~/Scripts/UpSetSel/setOpO1ins.tcl
		set substrate "Insulin"
	} elseif {[string match "13-*" $molname] || [string match "14-*" $molname]} {
		source ~/Scripts/UpSetSel/setOC0ins.tcl
		set substrate "ABeta"
	} else {
		puts "Something is wrong with your file names!"
	}

	### IDE Domain Coordinates ###
	# coordinates of IDE domains (and substrate cleavage sites) every frame
	set coordout [open "$molname-coords.txt" w+]
	puts $coordout "Mol Frame Domain AD1-X AD1-Y AD1-Z AD2-X AD2-Y AD2-Z Alink-X Alink-Y Alink-Z AD3-X AD3-Y AD3-Z AD4-X AD4-Y AD4-Z BD1-X BD1-Y BD1-Z BD2-X BD2-Y BD2-Z Blink-X Blink-Y Blink-Z BD3-X BD3-Y BD3-Z BD4-X BD4-Y BD4-Z aZn-X aZn-Y aZn-Z bZn-X bZn-Y bZn-Z insALY-X insALY-Y insALY-Z insAYQ-X insAYQ-Y insAYQ-Z insBSH-X insBSH-Y insBSH-Z insBHL-X insBHL-Y insBHL-Z insBEA-X insBEA-Y insBEA-z insBAL-X insBAL-Y insBAL-Z abVH-X abVH-Y abVH-Z abHH-X abHH-Y abHH-Z abHQ-X abHQ-Y abHQ-Z abFF-X abFF-Y abFF-Z abFA-X abFA-Y abFA-Z abKG-X abKG-Y abKG-Z"

	for {set frame 0} {$frame < $num_steps} {incr frame} {
			#IDE coordinates
		$ad1 frame $frame
		set ad1_com [measure center ${ad1} weight mass]
		$ad2 frame $frame
		set ad2_com [measure center ${ad2} weight mass]
		$an frame $frame
		set an_com [measure center ${an} weight mass]
		$alink frame $frame
		set alink_com [measure center ${alink} weight mass]
		$ad3 frame $frame
		set ad3_com [measure center ${ad3} weight mass]
		$ad4 frame $frame
		set ad4_com [measure center ${ad4} weight mass]
		$ac frame $frame
		set ac_com [measure center ${ac} weight mass]

		$bd1 frame $frame
		set bd1_com [measure center ${bd1} weight mass]
		$bd2 frame $frame
		set bd2_com [measure center ${bd2} weight mass]
		$bn frame $frame
		set bn_com [measure center ${bn} weight mass]
		$blink frame $frame
		set blink_com [measure center ${blink} weight mass]
		$bd3 frame $frame
		set bd3_com [measure center ${bd3} weight mass]
		$bd4 frame $frame
		set bd4_com [measure center ${bd4} weight mass]
		$bc frame $frame
		set bc_com [measure center ${bc} weight mass]

		$aZnCoord frame $frame
                set aZnC_com [measure center ${aZnCoord} weight mass]
		$bZnCoord frame $frame
                set bZnC_com [measure center ${bZnCoord} weight mass]

			#Put IDE stuff, and zeros for substrate values
		if {[string match "None" $substrate]} {
			puts $coordout "$molname $frame $ad1_com $ad2_com $alink_com $ad3_com $ad4_com $bd1_com $bd2_com $blink_com $bd3_com $bd4_com $aZnC_com $bZnC_com 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0"

			#Insulin cleavage coordinates replace certain zeroes
		} elseif {[string match "Insulin" $substrate]} {
			$insALY frame $frame
			set insALY_com [measure center ${insALY} weight mass]
			$insAYQ frame $frame
			set insAYQ_com [measure center ${insAYQ} weight mass]
			$insBSH frame $frame
			set insBSH_com [measure center ${insBSH} weight mass]
			$insBHL frame $frame
			set insBHL_com [measure center ${insBHL} weight mass]
			$insBEA frame $frame
			set insBEA_com [measure center ${insBEA} weight mass]
			$insBAL frame $frame
			set insBAL_com [measure center ${insBAL} weight mass]

			puts $coordout "$molname $frame $ad1_com $ad2_com $alink_com $ad3_com $ad4_com $bd1_com $bd2_com $blink_com $bd3_com $bd4_com $aZnC_com $bZnC_com $insALY_com $insAYQ_com $insBSH_com $insBHL_com $insBEA_com $insBAL_com 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0"


		} elseif {[string match "ABeta" $substrate]} {
			$abVH frame $frame
			set abVH_com [measure center ${abVH} weight mass]
			$abHH frame $frame
			set abHH_com [measure center ${abHH} weight mass]
			$abHQ frame $frame
			set abHQ_com [measure center ${abHQ} weight mass]
			$abFF frame $frame
			set abFF_com [measure center ${abFF} weight mass]
			$abFA frame $frame
			set abFA_com [measure center ${abFA} weight mass]
			$abKG frame $frame
			set abKG_com [measure center ${abKG} weight mass]
		
			puts $coordout "$molname $frame $ad1_com $ad2_com $alink_com $ad3_com $ad4_com $bd1_com $bd2_com $blink_com $bd3_com $bd4_com $aZnC_com $bZnC_com 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 $abVH_com $abHH_com $abHQ_com $abFF_com $abFA_com $abKG_com"

		} elseif {[string match "Undefined" $substrate]} {
			puts "Something's wrong!!"
		}


		}
	close $coordout
	set totfiles [llength $allvtfs]
	puts "Done with $molname. $filenum of $totfiles"
	mol delete top
}
puts "All done!"



