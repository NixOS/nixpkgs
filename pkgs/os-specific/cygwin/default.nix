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
      newlib-cygwin-headers = callPackage ./newlib-cygwin { headersOnly = true; };

      rebase = callPackage ./rebase { };

      tests = callPackage ./tests { };

      cygwinDllLinkHook = makeSetupHook {
        name = "cygwin-dll-link-hook";
        substitutions = {
          objdump = "${lib.getBin binutils-unwrapped}/${stdenv.targetPlatform.config}/bin/objdump";
        };
      } ./cygwin-dll-link.sh;
    };
}
