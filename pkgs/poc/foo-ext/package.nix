{ poc-foo, ... }:

(poc-foo.overrideLayer3 (
  {
    layer0Attrs,
    layer3Attrs,
    ...
  }:
  let
    inherit (layer0Attrs.__pkgs) pkgsBuildHost pkgsHostTarget;
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

    currentOutput = layer0Attrs; # use this to refer to current output
    theOutOutput = layer0Attrs.outputSet.out; # use this to refer to a specific output

    someVal = "123";

    sayer = pkgsBuildHost.kittysay;

    depsInPath = prevAttrs.depsInPath // {
      jdk = pkgsHostTarget.jdk17;
    };

    shellVars = prevAttrs.shellVars or { } // {
      inherit (layer0Attrs) someVal;
    };

    bruv = layer0Attrs.__pkgs;

    lowerOutputz = layer0Attrs.outputs;
    currentLayerOutputz = layer3Attrs.outputs;
  }
))

.overrideLayer1
  (
    { layer0Attrs, ... }:
    prevAttrs:
    prevAttrs
    // {

      stdenv = layer0Attrs.__pkgs.stdenvNoCC; # we could have overwritten it on higher layers btw

      x = prevAttrs;
      y = layer0Attrs;
    }
  )
