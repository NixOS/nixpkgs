let
  autoCalledPackages = import ./by-name-overlay.nix ../development/tcl-modules/by-name;
in

{
  lib,
  newScope,
  tcl,
  tk,
  pkgs,
}:

lib.makeScope newScope (
  lib.extends autoCalledPackages (self: {
    inherit tcl tk;
    inherit (tcl) mkTclDerivation tclPackageHook;

    critcl = self.callPackage ../development/tcl-modules/critcl {
      tcllib = self.tcllib.override { withCritcl = false; };
    };

    dbus = self.callPackage ../development/tcl-modules/dbus {
      inherit (pkgs) dbus;
    };
  })
)
