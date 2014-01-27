{ stdenv, fetchurl, flex }:
stdenv.mkDerivation {
  name = "xmlindent-0.2.17";
  src = fetchurl {
    url = http://downloads.sourceforge.net/project/xmlindent/xmlindent/0.2.17/xmlindent-0.2.17.tar.gz;
    sha256 = "0k15rxh51a5r4bvfm6c4syxls8al96cx60a9mn6pn24nns3nh3rs";
  };
  buildInputs = [ flex ];
  preConfigure = ''
    substituteInPlace Makefile --replace "PREFIX=/usr/local" "PREFIX=$out"
  '';
  meta = {
    license = stdenv.lib.licenses.gpl3;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.ocharles ];
  };
}
