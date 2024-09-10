{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "cpuid2cpuflags";
  version = "12";

  src = fetchurl {
    url =
      "https://github.com/projg2/${pname}/releases/download/v${version}/${pname}-${version}.tar.bz2";
    sha256 = "sha256-nTf6BDFqNgFqoUuebbnbEgF7/F+gY93n5noY5NSHk9I=";
  };

  meta = {
    description = "Tool to generate Gentoo CPU_FLAGS_* for your CPU";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ ehmry ];
    platforms = lib.platforms.linux;
  };
}
