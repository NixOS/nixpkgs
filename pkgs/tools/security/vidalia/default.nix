{ stdenv, fetchurl, cmake, qt4 }:
stdenv.mkDerivation rec {

  name = "vidalia-${version}";
  version = "0.2.15";

  src = fetchurl {
    url = "https://www.torproject.org/dist/vidalia/${name}.tar.gz";
    sha256 = "02c8q6l93w1f9jwnl13jvpzk8vms3lrqz41bs36ny7cfzgczv625";
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