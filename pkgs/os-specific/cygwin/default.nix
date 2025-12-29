{
  lib,
  makeScopeWithSplicing',
  generateSplicesForMkScope,
  makeSetupHook,
  binutils-unwrapped,
  stdenv,
}:

let
  otherSplices = generateSplicesForMkScope "cygwin";
in
makeScopeWithSplicing' {
  inherit otherSplices;
  f =
    self:
    let
      callPackage = self.callPackage;
    in
    {
      w32api = callPackage ./w32api { };
      w32api-headers = callPackage ./w32api { headersOnly = true; };

      newlib-cygwin = callPackage ./newlib-cygwin { };
      # this is here to avoid symlinks being made to cygwin1.dll in /nix/store
      newlib-cygwin-nobin = callPackage ./newlib-cygwin/nobin.nix { };
      newlib-cygwin-headers = callPackage ./newlib-cygwin { headersOnly = true; };

      cygwinDllLinkHook = makeSetupHook {
        name = "cygwin-dll-link-hook";
        substitutions = {
          objdump = "${lib.getBin binutils-unwrapped}/${stdenv.targetPlatform.config}/bin/objdump";
        };
      } ./cygwin-dll-link.sh;
    };
}
