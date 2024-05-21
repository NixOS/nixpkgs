{
  lib,
  mkDerivation,
  headers,
  common,
  libc,
  librt,
  sys,
}:

mkDerivation (
  import ./base.nix
  // {
    pname = "libpthread";
    installPhase = null;
    noCC = false;
    dontBuild = false;
    buildInputs = [ headers ];
    SHLIBINSTALLDIR = "$(out)/lib";
    extraPaths = [
      common
      libc.src
      librt.src
      sys.src
    ];
    meta.platforms = lib.platforms.netbsd;
  }
)
