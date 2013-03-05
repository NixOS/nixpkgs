{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "cifs-utils-5.6";

  src = fetchurl {
    url = "ftp://ftp.samba.org/pub/linux-cifs/cifs-utils/${name}.tar.bz2";
    sha256 = "0f619nw1163bcmfc83mmqj31qdkl68wfm81vynx3d8q0m0k1ll7i";
  };

  patches = [ ./find-systemd-ask-password-via-path.patch ];

  makeFlags = "root_sbindir=$(out)/sbin";

  meta = {
    homepage = http://www.samba.org/linux-cifs/cifs-utils/;
    description = "Tools for managing Linux CIFS client filesystems";
    platforms = stdenv.lib.platforms.linux;
  };
}
