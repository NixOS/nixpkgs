{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "cifs-utils-5.9";

  src = fetchurl {
    url = "ftp://ftp.samba.org/pub/linux-cifs/cifs-utils/${name}.tar.bz2";
    sha256 = "1wmfxbrkn0473pvzpa55qji60hr28ahwv5scxxi77x2lbki4l3gf";
  };

  patches = [ ./find-systemd-ask-password-via-path.patch ];

  makeFlags = "root_sbindir=$(out)/sbin";

  meta = {
    homepage = http://www.samba.org/linux-cifs/cifs-utils/;
    description = "Tools for managing Linux CIFS client filesystems";
    platforms = stdenv.lib.platforms.linux;
  };
}
