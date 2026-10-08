{
  lib,
  mkKdeDerivation,
  fetchurl,
  pkg-config,
  btrfs-progs,
}:
mkKdeDerivation rec {
  pname = "kio-snapshot";
  version = "1.0.0";

  src = fetchurl {
    url = "mirror://kde/stable/kio-snapshot/kio-snapshot-${version}.tar.xz";
    hash = "sha256-RxPQxgsYa+8LwPmSCTyLriRz03gIro1zF5qyVxzop9I=";
  };

  extraNativeBuildInputs = [ pkg-config ];

  extraBuildInputs = [ btrfs-progs ];

  meta = {
    license = lib.licenses.lgpl2Plus;
    maintainers = [ lib.maintainers.i-love-lean ];
  };
}
