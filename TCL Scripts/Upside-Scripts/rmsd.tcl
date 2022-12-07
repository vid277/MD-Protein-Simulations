set molname [molinfo top get name]
set num_steps [molinfo top get numframes]

set rmsdout [open "$traj-RMSD.txt" w+]

puts $rmsdout "Mol	!	Frame	!	All	A	B	AN	BN	CC"

set refAll [atomselect top "chain A or chain B" frame 0]
set refA [atomselect top "chain A" frame 0]
set refB [atomselect top "chain B" frame 0]
set refAN [atomselect top "chain A and resid 51 to 515" frame 0]
set refBN [atomselect top "chain B and resid 51 to 515" frame 0]
set refCC [atomselect top "resid 547 to 963 or resid 989 to 1007" frame 0]

set compAll [atomselect top "chain A or chain B"]
set compA [atomselect top "chain A"]
set compB [atomselect top "chain B"]
set compAN [atomselect top "chain A and resid 51 to 515"]
set compBN [atomselect top "chain B and resid 51 to 515"]
set compCC [atomselect top "resid 547 to 963 or resid 989 to 1007"]

for {set frame 0} {$frame < $num_steps} {incr frame} {

	$compAll frame $frame
	set All_transmat [measure fit $compAll $refAll]
        $compAll move $All_transmat
        set rmsdAll [measure rmsd $compAll $refAll]

	$compA frame $frame
	set A_transmat [measure fit $compA $refA]
        $compA move $A_transmat
        set rmsdA [measure rmsd $compA $refA]

	$compB frame $frame
	set B_transmat [measure fit $compB $refB]
        $compB move $B_transmat
        set rmsdB [measure rmsd $compB $refB]

	$compAN frame $frame
	set AN_transmat [measure fit $compAN $refAN]
        $compAN move $AN_transmat
        set rmsdAN [measure rmsd $compAN $refAN]

	$compBN frame $frame
	set BN_transmat [measure fit $compBN $refBN]
        $compBN move $BN_transmat
        set rmsdBN [measure rmsd $compBN $refBN]

	$compCC frame $frame
	set CC_transmat [measure fit $compCC $refCC]
	$compCC move $CC_transmat
	set rmsdCC [measure rmsd $compCC $refCC]

	puts $rmsdout  "$molname	!	$frame	!	$rmsdAll	$rmsdA	$rmsdB	$rmsdAN	$rmsdBN	$rmsdCC"
	puts "$traj RMSD: $frame of $num_steps"
}

close $rmsdout

