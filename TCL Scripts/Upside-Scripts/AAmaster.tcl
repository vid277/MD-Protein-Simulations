set trajlist { "00" "04" "06" "07" }

for {set i 0} { $i < [llength $trajlist] } { incr i } {
        set traj [lindex $trajlist $i]
        puts $traj

        if { [string match 00* $traj] } {
                mol new 00-OCinsA.pdb
                mol addfile 00-OCinsA.dcd waitfor all
        } elseif { [string match 04* $traj] } {
                mol new 04-OO.pdb
                mol addfile 04-OO.dcd waitfor all
        } elseif { [string match 06* $traj] } {
                mol new 06-OpO.pdb
                mol addfile 06-OpO.dcd waitfor all
        } elseif { [string match 07* $traj] } {
                mol new 07-OpOinsA.pdb
                mol addfile 07-OpOinsA.dcd waitfor all
        } else {
                puts "problemo!"
        }

        source /beagle3/wtang/NickScripts/setsel.tcl ; # Define atom selections that will be used
        source /beagle3/wtang/NickScripts/IDEhbonds.tcl ; # Calculate hydrogen bonds between N and C domains in Chain A and B

        if { [string match 00 $traj] || [string match 07 $traj]} {
                source ~/Scripts/3Dcoords.tcl ; # Get 3D coords for CoM of D1-4, Linker, Zn, Ins cleave sites
                source /beagle3/wtang/NickScripts/INShbonds.tcl ; # Get Hbonds involving insulin
                source /beagle3/wtang/NickScripts/insSS.tcl ; # Get insulin secondary structure
        } elseif { [string match 04 $traj] || [string match 06 $traj]} {
                source /beagle3/wtang/NickScripts/3Dapocoords.tcl ; # 3D coords for simulations without insulin
        } else {
                puts "problemo!"
        }

        source /beagle3/wtang/NickScripts/rmsd.tcl ; # Calculate domain-specific RMSDs for the simulation. MUST BE LAST because repositions mc for calcs

        puts "!!!!!!"
        puts "All done with $traj"
        puts "!!!!!!"
        mol delete top
}

