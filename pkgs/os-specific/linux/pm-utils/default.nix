{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "pm-utils-1.3.0";

  src = fetchurl {
    url = "http://pm-utils.freedesktop.org/releases/${name}.tar.gz";
    md5 = "37d71f8adbb409442212a85a080d324d";
  };

  configureFlags = "--sysconfdir=/etc";

  preConfigure =
    ''
      # Install the manpages (xmlto isn't really needed).
      substituteInPlace man/Makefile.in --replace '@HAVE_XMLTO_TRUE@' ""

      # Don't screw up the PATH.
      substituteInPlace pm/pm-functions.in --replace '/sbin:/usr/sbin:/bin:/usr/bin' '$PATH'

      substituteInPlace pm/sleep.d/00logging --replace /bin/uname "$(type -P uname)"
    '';

  meta = {
    homepage = http://pm-utils.freedesktop.org/wiki/;
    description = "A small collection of scripts that handle suspend and resume on behalf of HAL";
    license = "GPLv2";
  };
}
