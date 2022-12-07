# get sec str for insulin and abeta

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

	## Insulin and AB are mapped above; use it to get the SS from it in each frame
	set ssout [open "$molname-secstr.txt" w+]
	puts $ssout "Mol Frame Substrate! SecStr"
	
	if {[string match "Insulin" $substrate]} {
		for {set frame 0} {$frame < $num_steps} {incr frame 10} {
			animate goto $frame
			mol ssrecalc top
			set ssIns [$insCA get structure]
			puts $ssout "$molname $frame Insulin! $ssIns"
		}
	} elseif {[string match "ABeta" $substrate]} {
		for {set frame 0} {$frame < $num_steps} {incr frame 10} {
                	animate goto $frame
                	mol ssrecalc top
                	set ssAB [$abCA get structure]
        	        puts $ssout "$molname $frame ABeta! $ssAB"
	        }
	}

	close $ssout
	set totfiles [llength $allvtfs]
	puts "Done with $molname. $filenum of $totfiles"
	mol delete top
}

mkdir dir
mv *.txt dir

puts "All done!"
