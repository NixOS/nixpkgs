{
  lib,
  mkKdeDerivation,
  pkg-config,
  gocryptfs,
  fuse,
  cryfs,
  encfs,
}:
mkKdeDerivation {
  pname = "plasma-vault";

  patches = [
    ./0001-encfs-path.patch
    ./0002-cryfs-path.patch
    ./0003-fusermount-path.patch
    ./0004-gocryptfs-path.patch
  ];

  CXXFLAGS = [
    ''-DNIXPKGS_ENCFS=\"${lib.getBin encfs}/bin/encfs\"''
    ''-DNIXPKGS_ENCFSCTL=\"${lib.getBin encfs}/bin/encfsctl\"''
    ''-DNIXPKGS_CRYFS=\"${lib.getBin cryfs}/bin/cryfs\"''
    ''-DNIXPKGS_FUSERMOUNT=\"${lib.getBin fuse}/bin/fusermount\"''
    ''-DNIXPKGS_GOCRYPTFS=\"${lib.getBin gocryptfs}/bin/gocryptfs\"''
  ];

  extraNativeBuildInputs = [pkg-config];
}
