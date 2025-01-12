{
  lib,
  mkPackage,
  pkgsHostTarget, # we could also do finalAttrs.__pkgs.pkgsHostTarget, or use packages straight from the { ... }:
  pkgsBuildHost,
  ...
}:

mkPackage (
  { layer0Attrs, ... }:
  {
    name = "foooooo";

    src = pkgsHostTarget.balls.src;

    sayer = pkgsBuildHost.cowsay;

    installPhase = ''
      ${lib.getExe layer0Attrs.sayer} "My javac version is: $(javac -version 2>&1)"
      touch $out
    '';

    depsInPath = {
      jdk = pkgsBuildHost.jdk8;
    };

    ## this should probably go in mkPackage's definition
    nativeBuildInputs = lib.attrValues layer0Attrs.depsInPath;

    shellVars = {
      inherit (layer0Attrs) src installPhase nativeBuildInputs;
    };

  }
)
