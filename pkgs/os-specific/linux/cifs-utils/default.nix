{ stdenv, fetchurl, autoreconfHook, pkgconfig, kerberos, keyutils, pam, talloc }:

stdenv.mkDerivation rec {
  name = "cifs-utils-${version}";
  version = "6.7";

  src = fetchurl {
    url = "mirror://samba/pub/linux-cifs/cifs-utils/${name}.tar.bz2";
    sha256 = "1ayghnkryy1n1zm5dyvyyr7n3807nsm6glfcbbki5c2a8w91dwmj";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig ];
  buildInputs = [ kerberos keyutils pam talloc ];

  makeFlags = "root_sbindir=$(out)/sbin";

  meta = with stdenv.lib; {
    homepage = http://www.samba.org/linux-cifs/cifs-utils/;
    description = "Tools for managing Linux CIFS client filesystems";
    platforms = platforms.linux;
    license = licenses.lgpl3;
  };
}
