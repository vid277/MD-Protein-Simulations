set D1a [atomselect top "resid 58 to 104 or resid 541 to 749"]
set D1b [atomselect top "resid 435 to 479"]
set D1ab [atomselect top "resid 58 to 104 or resid 435 to 479 or resid 541 to 749"]

set D2 [atomselect top "resid 127 to 418 or resid 498 to 526"]

set S1 [atomselect top "resid 105 to 126"]
set S2 [atomselect top "resid 419 to 434"]
set S3 [atomselect top "resid 480 to 497"]
set S4 [atomselect top "resid 527 to 540"]

set S1andS2andS3andS4 [atomselect top "resid 105 to 126 or resid 419 to 434 or resid 480 to 497 or resid 527 to 540"]
set S1andS2andS3 [atomselect top "resid 105 to 126 or resid 419 to 434 or resid 480 to 497"]
set S1andS2andS4 [atomselect top "resid 105 to 126 or resid 419 to 434 or resid 527 to 540"]
set S1andS3andS4 [atomselect top "resid 105 to 126 or resid 480 to 497 or resid 527 to 540"]
set S2andS3andS4 [atomselect top "resid 419 to 434 or resid 480 to 497 or resid 527 to 540"]

set S1andS2 [atomselect top "resid 105 to 126 or resid 419 to 434"]
set S1andS3 [atomselect top "resid 105 to 126 or resid 480 to 497"]
set S1andS4 [atomselect top "resid 105 to 126 or resid 527 to 540"]

set S2andS3 [atomselect top "resid 419 to 434 or resid 480 to 497"]
set S2andS4 [atomselect top "resid 419 to 434 or resid 527 to 540"]

set S3andS4 [atomselect top "resid 480 to 497 or resid 527 to 540"]
