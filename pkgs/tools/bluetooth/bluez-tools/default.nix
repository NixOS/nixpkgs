{ stdenv, autoconf, automake, glib, pkgconfig, readline, fetchgit }:

stdenv.mkDerivation rec {
  date    = "2015-09-10";
  name    = "bluez-tools-${date}";
  rev     = "193ad6bb3db";

  src = fetchgit {
    inherit rev;
    url    = "https://github.com/khvzak/bluez-tools.git";
    sha256 = "0ylk10gfqlwmiz1k355axdhraixc9zym9f87xhag23934x64m8wa";
  };
  preConfigure = ''
    ./autogen.sh
  '';
  buildInputs = [ stdenv autoconf automake glib pkgconfig readline ];

  meta = with stdenv.lib; {
    description = "Command line bluetooth manager for Bluez5";
    license = stdenv.lib.licenses.gpl2;
    maintainers = [ maintainers.dasuxullebt ];
    platforms = platforms.unix;
  };

}
