{ stdenv, fetchurl, autoreconfHook, docutils, pkgconfig
, kerberos, keyutils, pam, talloc }:

stdenv.mkDerivation rec {
  name = "cifs-utils-${version}";
  version = "6.8";

  src = fetchurl {
    url = "mirror://samba/pub/linux-cifs/cifs-utils/${name}.tar.bz2";
    sha256 = "0ygz3pagjpaj5ky11hzh4byyymb7fpmqiqkprn11zwj31h2zdlg7";
  };

  nativeBuildInputs = [ autoreconfHook docutils pkgconfig ];

  buildInputs = [ kerberos keyutils pam talloc ];

  makeFlags = "root_sbindir=$(out)/sbin";

  meta = with stdenv.lib; {
    homepage = http://www.samba.org/linux-cifs/cifs-utils/;
    description = "Tools for managing Linux CIFS client filesystems";
    platforms = platforms.linux;
    license = licenses.lgpl3;
  };
}
