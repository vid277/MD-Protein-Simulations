set trajlist { "00" "04" "06" "07" }

for {set i 0} { $i < [llength $trajlist] } { incr i } {
        set traj [lindex $trajlist $i]
        puts $traj

        if { [string match 00* $traj] } {
                mol new 00-OCinsA.pdb
                mol addfile 00-All_noH2O.dcd waitfor all
        } elseif { [string match 04* $traj] } {
                mol new 04-OO.pdb
                mol addfile 04-All_noH2O.dcd waitfor all
        } elseif { [string match 06* $traj] } {
                mol new 06-OpO.pdb
                mol addfile 06-All_noH2O.dcd waitfor all
        } elseif { [string match 07* $traj] } {
                mol new 07-OpOinsA.pdb
                mol addfile 07-All_noH2O.dcd waitfor all
        } else {
                puts "problemo!"
        }

        source ~/Scripts/setsel.tcl ; # Define atom selections that will be used
        source ~/Scripts/IDEhbonds.tcl ; # Calculate hydrogen bonds between N and C domains in Chain A and B

        if { [string match 00 $traj] || [string match 07 $traj]} {
                source ~/Scripts/INShbonds.tcl ; # Get Hbonds involving insulin
        } else {
                puts "problemo!"
        }

        puts "!!!!!!"
        puts "All done with $traj"
        puts "!!!!!!"
        mol delete top
}

