{ tcl }:
self: {
  inherit tcl;
  tclPackages = self;
  inherit (tcl) mkTclDerivation;

  tcllib = self.callPackage ../development/tcl-modules/tcllib { };
}
