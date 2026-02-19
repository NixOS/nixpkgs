{
  lib,
  mkKdeDerivation,
  replaceVars,
  pkg-config,
  cryfs,
  encfs,
  fuse,
  gocryptfs,
  lsof,
}:
mkKdeDerivation {
  pname = "plasma-vault";

  patches = [
    (replaceVars ./hardcode-paths.patch {
      cryfs = lib.getExe' cryfs "cryfs";
      encfs = lib.getExe' encfs "encfs";
      encfsctl = lib.getExe' encfs "encfsctl";
      fusermount = lib.getExe' fuse "fusermount";
      gocryptfs = lib.getExe' gocryptfs "gocryptfs";
      lsof = lib.getExe lsof;
    })
  ];

  extraNativeBuildInputs = [ pkg-config ];
}
