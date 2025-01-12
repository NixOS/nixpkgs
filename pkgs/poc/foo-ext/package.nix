{ poc-foo, ... }:

poc-foo.overrideAttrs (
  finalAttrs:
  let
    inherit (finalAttrs.__pkgs) pkgsBuildHost pkgsHostTarget;
  in
  prevAttrs: {
    installPhase = ''
      ${prevAttrs.installPhase or ""}
      echo hello world $someVal
    '';

    outputs = [
      "out"
      "dev"
    ];

    someVal = "123";

    sayer = pkgsBuildHost.kittysay;

    depsInPath = prevAttrs.depsInPath // {
      jdk = pkgsHostTarget.jdk17;
    };

    shellVars = prevAttrs.shellVars or { } // {
      inherit (finalAttrs) someVal;
    };

    myself = finalAttrs;

    bruv = finalAttrs.__pkgs;

    outputz = finalAttrs.outputs; # outputs is actually set to [ "out" ] by default, even inside finalAttrs
  }
)
