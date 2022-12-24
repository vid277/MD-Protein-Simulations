#For VMD use cd ../../users/vidyo/desktop/sir/md-protein-simulations/scripts
#then run the script with source AAmaster.tcl

set trajlist { "00" "01" "02" "03" }

for {set i 0} { $i < [llength $trajlist] } { incr i } {
    set traj [lindex $trajlist $i]
    puts $traj

    if { [string match 00* $traj] } {

            mol new ../../221005_ZMP1/00-zmp1_closed/00_SI.psf
            mol addfile ../../221005_ZMP1/00-zmp1_closed/00_4NPT.dcd waitfor all

            set molecule "ZMP1-C"

            source zmp1_config.tcl;
            source 3Dcoords.tcl;    

    } elseif { [string match 01* $traj] } {

            mol new ../../221005_ZMP1/01-zmp1_open/01_SI.psf
            mol addfile ../../221005_ZMP1/01-zmp1_open/01_4NPT.dcd waitfor all

            set molecule "ZMP1-O"

            source zmp1_config.tcl;
            source 3Dcoords.tcl;    
    } elseif { [string match 02* $traj] } {

            mol new  ../../221019_NEPv/00-nepv_closed/00_SI.psf
            mol addfile ../../221019_NEPv/00-nepv_closed/00_4NPT.dcd waitfor all
        
            set molecule "NEPv-C"

            source nep_config.tcl;
            source 3Dcoords.tcl;    

    } elseif { [string match 03* $traj] } {

            mol new  ../../221019_NEPv/01-nepv_open/01_SI.psf
            mol addfile ../../221019_NEPv/01-nepv_open/01_4NPT.dcd waitfor all


            set molecule "NEPv-O"

            source nep_config.tcl;
            source 3Dcoords.tcl;    

    } elseif { [string match 03* $traj] } {

            mol new  ../../221026_NEP/00-nep_closed/00_SI.psf
            mol addfile ../../221026_NEP/00-nep_closed/00_3NPT.dcd waitfor all


            set molecule "NEP-C"

            source nep_config.tcl;
            source 3Dcoords.tcl;    

    } elseif { [string match 03* $traj] } {

            mol new  ../../221026_NEP/01-nep_open/01_SI.psf
            mol addfile ../../221026_NEP/01-nep_open/01_4NPT.dcd waitfor all

            set molecule "NEP-O"

            source nep_config.tcl;
            source 3Dcoords.tcl;    

    } else {
        puts "No match"
    }
}