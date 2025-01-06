{ lib, mkDerivation2, ... }:

(mkDerivation2 (finalAttrs: {
  name = "foooooo";

  src = finalAttrs.__pkgs.balls.src;

  sayer = finalAttrs.__pkgs.buildPackages.cowsay;

  installPhase = ''
    ${lib.getExe finalAttrs.sayer} "My javac version is: $(javac -version 2>&1)"

    touch $out
  '';

  depsInPath = {
    jdk = finalAttrs.__pkgs.pkgsBuildHost.jdk8;
  };

  ## this should probably go in mkDerivation2's definition
  nativeBuildInputs = lib.attrValues finalAttrs.depsInPath;

  shellVars = {
    inherit (finalAttrs) src installPhase nativeBuildInputs;
  };

  justTheAttrs = finalAttrs;
}))
