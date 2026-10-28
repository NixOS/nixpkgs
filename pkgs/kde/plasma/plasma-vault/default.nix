{
  lib,
  mkKdeDerivation,
  replaceVars,
  pkg-config,
  gocryptfs,
  lsof,
}:
mkKdeDerivation {
  pname = "plasma-vault";

  patches = [
    (replaceVars ./hardcode-paths.patch {
      gocryptfs = lib.getExe' gocryptfs "gocryptfs";
      lsof = lib.getExe lsof;
    })
  ];

  extraNativeBuildInputs = [ pkg-config ];
}
