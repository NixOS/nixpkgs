{ poc-foo, ... }:

(poc-foo.overrideLayer3 (
  finalAttrs:
  let
    inherit (finalAttrs.finalLayer1Attrs.__pkgs) pkgsBuildHost pkgsHostTarget;
  in
  prevAttrs:
  prevAttrs
  // {

    installPhase = ''
      ${prevAttrs.installPhase or ""}
      echo hello world $someVal
      touch $out2

    '';

    outputs = [
      "out"
      "out2"
    ];

    someVal = "123";

    sayer = pkgsBuildHost.kittysay;

    depsInPath = prevAttrs.depsInPath // {
      jdk = pkgsHostTarget.jdk17;
    };

    shellVars = prevAttrs.shellVars or { } // {
      inherit (finalAttrs) someVal;
    };

    #myself = finalAttrs;

    bruv = finalAttrs.finalLayer1Attrs.__pkgs;

    lowerOutputz = finalAttrs.finalLayer1Attrs.outputs;
    currentLayerOutputz = finalAttrs.outputs;
  }
))

.overrideLayer1
  (
    finalAttrs: prevAttrs:
    prevAttrs
    // {

      stdenv = finalAttrs.__pkgs.stdenvNoCC; # we could have overwritten it on higher layers btw

      x = prevAttrs;
      y = finalAttrs;
    }
  )
