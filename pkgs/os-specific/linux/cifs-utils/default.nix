{ stdenv, fetchurl, kerberos, keyutils, pam, talloc }:

stdenv.mkDerivation rec {
  name = "cifs-utils-${version}";
  version = "6.6";

  src = fetchurl {
    url = "mirror://samba/pub/linux-cifs/cifs-utils/${name}.tar.bz2";
    sha256 = "09biws1jm23l3mjb9kh99v57z8bgzybrmimwddb40s6y0yl54wfh";
  };

  buildInputs = [ kerberos keyutils pam talloc ];

  makeFlags = "root_sbindir=$(out)/sbin";

  meta = with stdenv.lib; {
    homepage = http://www.samba.org/linux-cifs/cifs-utils/;
    description = "Tools for managing Linux CIFS client filesystems";
    platforms = platforms.linux;
    license = licenses.lgpl3;
    maintainers = with maintainers; [ nckx ];
  };
}
