{ stdenv, autoconf, automake, glib, pkgconfig, readline, fetchgit }:

stdenv.mkDerivation rec {
  date    = "2015-09-10";
  name    = "bluez-tools-${date}";
  rev     = "193ad6bb3db";

  src = fetchgit {
    inherit rev;
    url    = "https://github.com/khvzak/bluez-tools.git";
    sha256 = "3f264d14ba8ef1b0d3c45e621a5c685035a60d789da64f64d25055047f45c55b";
  };
  preConfigure = ''
    ./autogen.sh
  '';
  buildInputs = [ stdenv autoconf automake glib pkgconfig readline ];

  meta = with stdenv.lib; {
    description = "Command line bluetooth manager for Bluez5";
    license = stdenv.lib.licenses.gpl2;
    maintainers = [ maintainers.dasuxullebt ];
  };

}
