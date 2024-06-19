{
  lib,
  mkDerivation,
  headers,
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
      "common"
      libc.path
      librt.path
      sys.path
    ];
    meta.platforms = lib.platforms.netbsd;
  }
)
