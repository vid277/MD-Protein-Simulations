set sel [atomselect top "protein or resname ZN2"]
set ofile [open "index.ind" "w"]
puts $ofile [$sel get index]
close $ofile
