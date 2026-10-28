{
  lib,
  mkKdeDerivation,
  fetchurl,
  pkg-config,
  btrfs-progs,
}:
mkKdeDerivation rec {
  pname = "kio-snapshot";
  version = "1.1.0";

  src = fetchurl {
    url = "mirror://kde/stable/kio-snapshot/kio-snapshot-${version}.tar.xz";
    hash = "sha256-xWpBzBZGAxR04cjIDJckcdVf/6rQN+Nsp86/EoMDGUc=";
  };

  extraNativeBuildInputs = [ pkg-config ];

  extraBuildInputs = [ btrfs-progs ];

  meta = {
    license = lib.licenses.lgpl2Plus;
    maintainers = [ lib.maintainers.i-love-lean ];
  };
}
