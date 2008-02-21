export NIX_ENFORCE_PURITY=
export NIX_DONT_SET_RPATH=1
export NIX_NO_SELF_RPATH=1
dontFixLibtool=1
NIX_STRIP_DEBUG=0
stripAllFlags=" " # the Darwin "strip" command doesn't know "-s" 
