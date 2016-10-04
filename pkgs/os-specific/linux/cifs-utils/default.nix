{ stdenv, fetchurl, kerberos, keyutils, pam }:

stdenv.mkDerivation rec {
  name = "cifs-utils-${version}";
  version = "6.5";

  src = fetchurl {
    url = "mirror://samba/pub/linux-cifs/cifs-utils/${name}.tar.bz2";
    sha256 = "1xs9rwqfpx8qj5mcmagw6y1hzwc71zhzb5r8hv06sz16p1w6axz2";
  };

  buildInputs = [ kerberos keyutils pam ];

  makeFlags = "root_sbindir=$(out)/sbin";

  meta = with stdenv.lib; {
    homepage = http://www.samba.org/linux-cifs/cifs-utils/;
    description = "Tools for managing Linux CIFS client filesystems";
    platforms = platforms.linux;
    license = licenses.lgpl3;
    maintainers = with maintainers; [ nckx ];
  };
}
