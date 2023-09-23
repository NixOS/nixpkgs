{ stdenvAdapters, pkgs }:
let
  stdenv = pkgs.stdenv;
  platformStatic = stdenv.hostPlatform // { isStatic = true; };
  stdenvStatic = (stdenvAdapters.makeStatic stdenv) // { hostPlatform = platformStatic; };
  mkStatic = pkg: ((pkg.override { stdenv = stdenvStatic; }).overrideAttrs { hardeningDisable = [ "all" ]; });
in
  {
    bash = mkStatic pkgs.bash;
    patchelf = mkStatic pkgs.patchelf;
    gnutar = mkStatic pkgs.gnutar;
    xz = mkStatic pkgs.xz;
    coreutils = (mkStatic pkgs.coreutils).override { gmpSupport = false; libiconv = pkgs.libiconvReal.override { enableStatic = true; }; };
  }
