{ stdenv, fetchurl, kerberos, keyutils, pam }:

stdenv.mkDerivation rec {
  name = "cifs-utils-6.4";

  src = fetchurl {
    url = "ftp://ftp.samba.org/pub/linux-cifs/cifs-utils/${name}.tar.bz2";
    sha256 = "1qz6d2xg4z1if0hy7qwyzgcr59l0alkhci6gxgjdldglda967z1q";
  };

  buildInputs = [ kerberos keyutils pam ];

  makeFlags = "root_sbindir=$(out)/sbin";

  meta = with stdenv.lib; {
    homepage = http://www.samba.org/linux-cifs/cifs-utils/;
    description = "Tools for managing Linux CIFS client filesystems";
    platforms = platforms.linux;
    license = licenses.lgpl3;
  };
}
