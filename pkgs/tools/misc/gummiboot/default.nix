{ stdenv, fetchurl, gnu_efi, unzip, pkgconfig, utillinux, libxslt, docbook_xsl, docbook_xml_dtd_42 }:

stdenv.mkDerivation rec {
  name = "gummiboot-23";

  buildInputs = [ unzip pkgconfig utillinux libxslt docbook_xsl docbook_xml_dtd_42 ];

  patches = [ ./no-usr.patch ];

  buildFlags = [ "GNU_EFI=${gnu_efi}" ];

  makeFlags = [ "PREFIX=$(out)" ];

  src = fetchurl {
    url = "http://cgit.freedesktop.org/gummiboot/snapshot/${name}.zip";
    sha256 = "1lmfk4k52ha00ppna5g7h51vhd27i9fipf5k7mc2d9jkm2480z4j";
  };

  meta = {
    description = "A simple UEFI boot manager which executes configured EFI images";

    homepage = http://freedesktop.org/wiki/Software/gummiboot;

    license = stdenv.lib.licenses.lgpl21Plus;

    platforms = [ "x86_64-linux" "i686-linux" ];

    maintainers = [ stdenv.lib.maintainers.shlevy ];
  };
}
