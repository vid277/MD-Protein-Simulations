set allvtfs [glob -directory "allVTFs" -- "*.vtf"]
set filenum 0
foreach v $allvtfs {
	mol load vtf $v
	incr filenum

	set molname [molinfo top get name]
	set numframes [molinfo top get numframes]
	
	#Set the domains appropriately for each molecule
	if {[string match "00-*" $molname] || [string match "01-*" $molname] || [string match "08-*" $molname] || [string match "10-*" $molname] || [string match "11-*" $molname] || [string match "12-*" $molname] || [string match "15-*" $molname] || [string match "16-*" $molname] ||[string match "17-*" $molname] || [string match "18-*" $molname] || [string match "22-*" $molname] ||[string match "23-*" $molname] } {
		source setOC1ins.tcl
		set substrate "Insulin"
	} elseif {[string match "02-*" $molname] || [string match "05-*" $molname]} {
		source setOO1ins.tcl
		set substrate "Insulin"
	} elseif {[string match "04-*" $molname]} {
		source setOO0ins.tcl
		set substrate "None"
	} elseif {[string match "06-*" $molname]} {
		source setOpO0ins.tcl
		set substrate "None"
	} elseif {[string match "07-*" $molname] || [string match "09-*" $molname] || [string match "19-*" $molname] || [string match "21-*" $molname] } {
		source setOpO1ins.tcl
		set substrate "Insulin"
	} elseif {[string match "13-*" $molname] || [string match "14-*" $molname]} {
		source setOC0ins.tcl
		set substrate "ABeta"
	} else {
		puts "Something is wrong with your file names!"
	}

	puts "$molname IDE-Sub Hbonds for $numframes frames"
	puts "1"
        if {[string match "13-*" $molname] || [string match "14-*" $molname]} {
                for {set frame 0} {${frame} < ${numframes}} {incr frame} {
                        hbonds -sel1 $IDEall -sel2 $abAll -writefile no -frames $frame:$frame -plot no -writefile yes -type all -outfile $molname-$frame-InsIDEhbonds.dat -detailout $molname-$frame-InsIDEhbonds_detail.dat
                puts "Hbonds details for $molname: $frame of $numframes"
        	puts "2"
		}
	} else {
                for {set frame 0} {${frame} < ${numframes}} {incr frame} {
               		hbonds -sel1 $IDEall -sel2 $insAll -writefile no -frames $frame:$frame -plot no -writefile yes -type all -outfile $molname-$frame-InsIDEhbonds.dat -detailout $molname-$frame-InsIDEhbonds_detail.dat
                puts "Hbonds details for $molname: $frame of $numframes"
        	puts "3"	
		}
	}

        set totfiles [llength $allvtfs]
        puts "Done with $molname. $filenum of $totfiles"
        puts "4"
	mol delete top

}
puts "All done!"
