set D1a [atomselect top "resid 1 to 46 or resid 451 to 663"]
set D1b [atomselect top "resid 353 to 397"]
set D1ab [atomselect top "resid 1 to 46 or resid 451 to 663 or resid 353 to 397"]

set D2 [atomselect top "resid 72 to 336 or resid 408 to 436"]

set S1 [atomselect top "resid 47 to 71"]
set S2 [atomselect top "resid 337 to 352"]
set S3 [atomselect top "resid 398 to 407"]
set S4 [atomselect top "resid 437 to 450"]

set S1andS2andS3andS4 [atomselect top "resid 47 to 71 or resid 337 to 352 or resid 398 to 407 or resid 437 to 450"]
set S1andS2andS3 [atomselect top "resid 47 to 71 or resid 337 to 352 or resid 398 to 407"]
set S2andS3andS4 [atomselect top "resid 337 to 352 or resid 398 to 407 or resid 437 to 450"]
set S1andS3andS4 [atomselect top "resid 47 to 71 or resid 398 to 407 or resid 437 to 450"]
set S1andS2andS4 [atomselect top "resid 47 to 71 or resid 337 to 352 or resid 437 to 450"]


set S1andS2 [atomselect top "resid 47 to 71 or resid 337 to 352"]
set S1andS3 [atomselect top "resid 47 to 71 or resid 398 to 407"]
set S1andS4 [atomselect top "resid 47 to 71 or resid 437 to 450"]

set S2andS3 [atomselect top "resid 337 to 352 or resid 398 to 407"]
set S2andS4 [atomselect top "resid 337 to 352 or resid 437 to 450"]

set S3andS4 [atomselect top "resid 398 to 407 or resid 437 to 450"]

set Zinc [atomselect top "chain E or (chain A and resid 493 494 495 496 497)"]