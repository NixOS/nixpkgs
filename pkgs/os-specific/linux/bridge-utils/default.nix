{ lib, stdenv, fetchurl, autoreconfHook }:

stdenv.mkDerivation rec {
  pname = "bridge-utils";
  version = "1.7.1";

  src = fetchurl {
    url = "https://kernel.org/pub/linux/utils/net/bridge-utils/bridge-utils-${version}.tar.xz";
    sha256 = "sha256-ph2L5PGhQFxgyO841UTwwYwFszubB+W0sxAzU2Fl5g4=";
  };

  patches = [ ./autoconf-ar.patch ];

  nativeBuildInputs = [ autoreconfHook ];

  meta = {
    description = "An userspace tool to configure linux bridges (deprecated in favour or iproute2).";
    homepage = "https://wiki.linuxfoundation.org/networking/bridge";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
}
