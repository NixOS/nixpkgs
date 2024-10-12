{ lib, stdenv, fetchurl, gettext }:

stdenv.mkDerivation rec {
  pname = "ms-sys";
  version = "2.6.0";

  src = fetchurl {
    url = "mirror://sourceforge/ms-sys/ms-sys-${version}.tar.gz";
    sha256 = "06xqpm2s9cg8fj7a1822wmh3p4arii0sifssazg1gr6i7xg7kbjz";
  };
  # TODO: Remove with next release, see https://sourceforge.net/p/ms-sys/patches/8/
  patches = [ ./manpages-without-build-timestamps.patch ];

  nativeBuildInputs = [ gettext ];

  enableParallelBuilding = true;

  makeFlags = [ "PREFIX=$(out)" ];

  meta = with lib; {
    description = "Program for writing Microsoft-compatible boot records";
    homepage = "https://ms-sys.sourceforge.net/";
    license = licenses.gpl2Plus;
    platforms = with platforms; linux;
    mainProgram = "ms-sys";
  };
}
