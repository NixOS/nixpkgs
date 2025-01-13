{
  lib,
  mkPackage,
  pkgsHostTarget, # we could also do finalAttrs.__pkgs.pkgsHostTarget, or use packages straight from the { ... }:
  pkgsBuildHost,
  ...
}:

mkPackage (
  { finalAttrs, ... }:
  {
    name = "foooooo";

    src = pkgsHostTarget.balls.src;

    sayer = pkgsBuildHost.cowsay;

    installPhase = ''
      echo $nums
      ${lib.getExe finalAttrs.sayer} "My javac version is: $(javac -version 2>&1)"
      touch $out
    '';

    depsInPath = {
      jdk = pkgsBuildHost.jdk8;
    };

    shellVars = {
      nums = "012345";
    };

    ## this should probably go in mkPackage's definition
    nativeBuildInputs = lib.attrValues finalAttrs.depsInPath;

  }
)
