{ stdenv, fetchurl, qmake, boost }:

stdenv.mkDerivation rec {

  name = "glogg-${version}";
  version = "1.1.4";

  src = fetchurl {
    url = "https://glogg.bonnefon.org/files/${name}.tar.gz";
    sha256 = "0nwnfk9bcz2k7rf08w2cb6qipzdhwmxznik44jxmn9gwxdrdq78c";
  };

  nativeBuildInputs = [ qmake ];
  buildInputs = [ boost ];

  qmakeFlags = [ "glogg.pro" ];
  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "The fast, smart log explorer";
    longDescription = ''
      A multi-platform GUI application to browse and search through long or complex log files. It is designed with programmers and system administrators in mind. glogg can be seen as a graphical, interactive combination of grep and less.
    '';
    homepage = https://glogg.bonnefon.org/;
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ c0bw3b ];
  };
}
