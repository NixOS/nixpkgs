{ lib, stdenv, fetchurl, perl }:

stdenv.mkDerivation rec {
  pname = "wol";
  version = "0.7.1";

  src = fetchurl {
    url = "mirror://sourceforge/wake-on-lan/${pname}-${version}.tar.gz";
    sha256 = "08i6l5lr14mh4n3qbmx6kyx7vjqvzdnh3j9yfvgjppqik2dnq270";
  };

  # for pod2man in order to get a manpage
  nativeBuildInputs = [ perl ];

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Implements Wake On LAN functionality in a small program";
    homepage = "https://sourceforge.net/projects/wake-on-lan/";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ makefu ];
    mainProgram = "wol";
    platforms = platforms.linux;
  };
}
