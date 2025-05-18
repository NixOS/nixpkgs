{ poc-foo, ... }:

(poc-foo.overrideLayer3 (
  {
    finalAttrs,
    layer3Attrs,
    ...
  }:
  let
    inherit (finalAttrs.__pkgs) pkgsBuildHost pkgsHostTarget;
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

    # THIS IS NOT HOW IT WORKS WITH MKDERIVATION
    currentOutput = finalAttrs; # use this to refer to currently selected output
    theOutOutput = finalAttrs.outputSet.out; # use this to refer to a specific output

    someVal = "123";

    sayer = pkgsBuildHost.kittysay;

    depsInPath = prevAttrs.depsInPath // {
      jdk = pkgsHostTarget.jdk17;
    };

    shellVars = prevAttrs.shellVars or { } // {
      inherit (finalAttrs) someVal;
    };

    bruv = finalAttrs.__pkgs;

    lowerOutputz = finalAttrs.outputs;
    currentLayerOutputz = layer3Attrs.outputs; # if we want to keep the ability to reference layers other than layer0, maybe add a way to reference current layer
  }
))

.overrideLayer1
  (
    { finalAttrs, ... }:
    prevAttrs:
    prevAttrs
    // {

      stdenv = finalAttrs.__pkgs.stdenvNoCC; # we could have overwritten it on higher layers btw

      x = prevAttrs; # prevAttrs is the previous version of layer1
    }
  )
