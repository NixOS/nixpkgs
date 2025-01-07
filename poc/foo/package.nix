{
  lib,
  mkDerivation2,
  pkgsHostTarget, # we could also do finalAttrs.__pkgs.pkgsHostTarget, or use packages straight from the { ... }:
  pkgsBuildHost,
  ...
}:

(mkDerivation2 (finalAttrs: {
  name = "foooooo";

  src = pkgsHostTarget.balls.src;

  sayer = pkgsBuildHost.cowsay;

  installPhase = ''
    ${lib.getExe finalAttrs.sayer} "My javac version is: $(javac -version 2>&1)"
    touch $out
  '';

  depsInPath = {
    jdk = pkgsBuildHost.jdk8;
  };

  ## this should probably go in mkDerivation2's definition
  nativeBuildInputs = lib.attrValues finalAttrs.depsInPath;

  shellVars = {
    inherit (finalAttrs) src installPhase nativeBuildInputs;
  };

  justTheAttrs = finalAttrs;
}))
