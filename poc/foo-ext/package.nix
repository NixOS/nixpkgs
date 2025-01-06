{ poc-foo, ... }:

poc-foo.overrideAttrs (
  finalAttrs: prevAttrs: {
    installPhase = ''
      ${prevAttrs.installPhase or ""}
      echo hello world $someVal
    '';

    someVal = "123";

    sayer = finalAttrs.__pkgs.buildPackages.kittysay;

    depsInPath = prevAttrs.depsInPath // {
      jdk = finalAttrs.__pkgs.jdk17;
    };

    shellVars = prevAttrs.shellVars or { } // {
      inherit (finalAttrs) someVal;
    };

    myself = finalAttrs.finalPackage;

    bruv = finalAttrs.__pkgs;

    outputz = finalAttrs.outputs; # outputs is actually set to [ "out" ] by default, even inside finalAttrs
  }
)
