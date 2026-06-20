{
  lib,
  mkKdeDerivation,
  replaceVars,
  pkg-config,
  cryfs,
  gocryptfs,
  lsof,
}:
mkKdeDerivation {
  pname = "plasma-vault";

  patches = [
    (replaceVars ./hardcode-paths.patch {
      cryfs = lib.getExe' cryfs "cryfs";
      gocryptfs = lib.getExe' gocryptfs "gocryptfs";
      lsof = lib.getExe lsof;
    })
  ];

  extraNativeBuildInputs = [ pkg-config ];
}
