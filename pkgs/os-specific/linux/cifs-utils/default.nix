{ stdenv, fetchurl, autoreconfHook, docutils, pkgconfig
, kerberos, keyutils, pam, talloc, fetchpatch }:

stdenv.mkDerivation rec {
  pname = "cifs-utils";
  version = "6.9";

  src = fetchurl {
    url = "mirror://samba/pub/linux-cifs/cifs-utils/${pname}-${version}.tar.bz2";
    sha256 = "175cp509wn1zv8p8mv37hkf6sxiskrsxdnq22mhlsg61jazz3n0q";
  };

  nativeBuildInputs = [ autoreconfHook docutils pkgconfig ];

  buildInputs = [ kerberos keyutils pam talloc ];

  patches = [
    (fetchpatch {
      name = "CVE-2020-14342.patch";
      url = "https://attachments.samba.org/attachment.cgi?id=16148";
      sha256 = "1xw3d11wb1l8a89jhdp6hhy987nq0gafxfhx5jdhcc5nazahc7s4";
    })
    (fetchpatch {
      name = "CVE-2021-20208.patch";
      url = "https://attachments.samba.org/attachment.cgi?id=16477";
      sha256 = "1nic669fa65r845pxfb6lmfs78g7aqbaz86r0axm332inb60hj10";
    })
  ];

  makeFlags = [ "root_sbindir=$(out)/sbin" ];

  meta = with stdenv.lib; {
    homepage = "https://wiki.samba.org/index.php/LinuxCIFS_utils";
    description = "Tools for managing Linux CIFS client filesystems";
    platforms = platforms.linux;
    license = licenses.lgpl3;
  };
}
