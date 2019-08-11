{ stdenv, fetchurl }:

stdenv.mkDerivation {
  name = "lsscsi-0.30";

  src = fetchurl {
    url = "http://sg.danny.cz/scsi/lsscsi-0.30.tgz";
    sha256 = "05cba72m0hj3kpikk26h7j02cly7zy5lgww2fvswa0jz823j36k1";
  };

  preConfigure = ''
    substituteInPlace Makefile.in --replace /usr "$out"
  '';

  meta = with stdenv.lib; {
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
