{ stdenv, fetchurl, cmake, qt4 }:
stdenv.mkDerivation rec {

  name = "vidalia-${version}";
  version = "0.2.17";

  src = fetchurl {
    url = "https://www.torproject.org/dist/vidalia/${name}.tar.gz";
    sha256 = "0x0vb37h2d5njxmqkss03ybv7b7jw25682xb793mix1m8l0hs44r";
  };

  buildInputs = [ cmake qt4 ];

  meta = with stdenv.lib; {
    homepage = https://www.torproject.org/projects/vidalia.html.en;
    description = "a cross-platform graphical controller for the Tor software, built using the Qt framework";
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.phreedom ];
    platforms = platforms.all;
  };
}