#For VMD use cd ../../users/vidyo/desktop/sir/md-protein-simulations/scripts
#then run the script with source AAmaster.tcl

set trajlist { "00" "01" "02" "03" }

for {set i 0} { $i < [llength $trajlist] } { incr i } {
    set traj [lindex $trajlist $i]
    puts $traj

    if { [string match 00* $traj] } {

            mol new ../RUNS/00-zmp1-c/zmp1-c.pdb
            mol addfile ../RUNS/00-zmp1-c/zmp1-c.dcd waitfor all

            set molecule "ZMP1-C"

            source zmp1_config.tcl;
            source 3Dcoords.tcl;    

    } elseif { [string match 01* $traj] } {

            mol new ../RUNS/01-zmp1-o/zmp1-o.pdb
            mol addfile ../RUNS/01-zmp1-o/zmp1-o.dcd waitfor all

            set molecule "ZMP1-O"

            source zmp1_config.tcl;
            source 3Dcoords.tcl;    


    } elseif { [string match 02* $traj] } {

            mol new ../RUNS/02-nep_hum-c/nep_hum-c.pdb
            mol addfile ../RUNS/02-nep_hum-c/nep_hum-c.dcd waitfor all
        
            set molecule "NEP_HUM-C"

            source nep_hum_config.tcl;
            source 3Dcoords.tcl;    

    } elseif { [string match 03* $traj] } {

            mol new ../RUNS/03-nep_hum-o/nep_hum-o.pdb
            mol addfile ../RUNS/03-nep_hum-o/nep_hum-o.dcd waitfor all

            set molecule "NEP_HUM-O"

            source nep_hum_config.tcl;
            source 3Dcoords.tcl;    

    } else {
        puts "No match"
    }
}