        set insAYQ [atomselect top "chain C and resid 14 or resid 15"]
        set insBHL [atomselect top "chain D and resid 10 or resid 11"]

	set AznCoord [atomselect top "(chain Y) or (chain A and resid 108 111 112 189)"]
	set BznCoord [atomselect top "(chain Z) or (chain B and resid 108 111 112 189)"]

        set ad1 [atomselect top "protein and chain A and resid 51 to 285"]
        set ad2 [atomselect top "protein and chain A and resid 286 to 515"]
        set andomain [atomselect top "protein and chain A and resid 51 to 515"]
	set anCA [atomselect top "protein and chain A and name CA and resid 51 to 515"]
	set alink [atomselect top "protein and chain A and resid 516 to 541"]
        set ad3 [atomselect top "protein and chain A and resid 542 to 768"]
        set ad4 [atomselect top "protein and chain A and (resid 769 to 963 or resid 989 to 1007)"]
	set acdomain [atomselect top "protein and chain A and (resid 542 to 963 or resid 989 to 1007)"]
	set acCA [atomselect top "protein and chain A and name CA and (resid 542 to 963 or resid 989 to 1007)"]
	set aAll [atomselect top "protein and chain A"]

        set bd1 [atomselect top "protein and chain B and resid 51 to 285"]
        set bd2 [atomselect top "protein and chain B and resid 286 to 515"]
	set bndomain [atomselect top "protein and chain B and resid 51 to 515"]
	set bnCA [atomselect top "protein and chain B and name CA and resid 51 to 515"]
        set blink [atomselect top "protein and chain B and resid 516 to 541"]
        set bd3 [atomselect top "protein and chain B and resid 542 to 768"]
        set bd4 [atomselect top "protein and chain B and (resid 769 to 963 or resid 989 to 1007)"]
	set bcdomain [atomselect top "protein and chain B and (resid 542 to 963 or resid 989 to 1007)"]
	set bcCA [atomselect top "protein and chain B and name CA and (resid 542 to 963 or resid 989 to 1007)"]
	set bAll [atomselect top "protein and chain B"]

	set IDEall [atomselect top "protein and (chain A or chain B)"]

        set insA [atomselect top "protein and (chain C or chain E)"]
        set insB [atomselect top "protein and (chain D or chain F)"]
	set insCA [atomselect top "protein and name CA and (chain C or chain D or chain E or chain F)"]
	set insAll [atomselect top "protein and (chain C or chain D or chain E or chain F)"]



