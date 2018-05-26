{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  version = "4.8.6";
  name = "debianutils-${version}";

  src = fetchurl {
    url = "mirror://debian/pool/main/d/debianutils/debianutils_${version}.tar.xz";
    sha256 = "0wrz8ak4896f5i8wirijr9hdvc43xzxpg2gjs0snmpys8iqh82fv";
  };

  meta = {
    description = "Miscellaneous utilities specific to Debian";
    longDescription = ''
       This package provides a number of small utilities which are used primarily by the installation scripts of Debian packages, although you may use them directly.

       The specific utilities included are: add-shell installkernel ischroot remove-shell run-parts savelog tempfile which
    '';
    downloadPage = https://packages.debian.org/sid/debianutils;
    license = with stdenv.lib.licenses; [ gpl2Plus publicDomain smail ];
    maintainers = [];
    platforms = stdenv.lib.platforms.all;
  };
}
