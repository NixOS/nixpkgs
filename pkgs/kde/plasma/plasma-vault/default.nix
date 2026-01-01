{
  lib,
  mkKdeDerivation,
<<<<<<< HEAD
  replaceVars,
  pkg-config,
  cryfs,
  encfs,
  fuse,
  gocryptfs,
  lsof,
=======
  pkg-config,
  gocryptfs,
  fuse,
  cryfs,
  encfs,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
}:
mkKdeDerivation {
  pname = "plasma-vault";

  patches = [
<<<<<<< HEAD
    (replaceVars ./hardcode-paths.patch {
      cryfs = lib.getExe' cryfs "cryfs";
      encfs = lib.getExe' encfs "encfs";
      encfsctl = lib.getExe' encfs "encfsctl";
      fusermount = lib.getExe' fuse "fusermount";
      gocryptfs = lib.getExe' gocryptfs "gocryptfs";
      lsof = lib.getExe lsof;
    })
=======
    ./0001-encfs-path.patch
    ./0002-cryfs-path.patch
    ./0003-fusermount-path.patch
    ./0004-gocryptfs-path.patch
  ];

  CXXFLAGS = [
    ''-DNIXPKGS_ENCFS=\"${lib.getBin encfs}/bin/encfs\"''
    ''-DNIXPKGS_ENCFSCTL=\"${lib.getBin encfs}/bin/encfsctl\"''
    ''-DNIXPKGS_CRYFS=\"${lib.getBin cryfs}/bin/cryfs\"''
    ''-DNIXPKGS_FUSERMOUNT=\"${lib.getBin fuse}/bin/fusermount3\"''
    ''-DNIXPKGS_GOCRYPTFS=\"${lib.getBin gocryptfs}/bin/gocryptfs\"''
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  ];

  extraNativeBuildInputs = [ pkg-config ];
}
