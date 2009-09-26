{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "pm-utils-1.2.5";

  src = fetchurl {
    url = "http://pm-utils.freedesktop.org/releases/${name}.tar.gz";
    sha256 = "1kp4l21786kbvnzlf3n9svl4m93nzi1hr9pknv0r3zhzfz3hgkw4";
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
