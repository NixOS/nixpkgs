{ stdenv, fetchurl, gnu-efi, unzip, pkgconfig, utillinux, libxslt, docbook_xsl, docbook_xml_dtd_42 }:

stdenv.mkDerivation rec {
  name = "gummiboot-45";

  buildInputs = [ gnu-efi pkgconfig libxslt utillinux ];

  # Sigh, gummiboot should be able to find this in buildInputs
  configureFlags = [
    "--with-efi-includedir=${gnu-efi}/include"
    "--with-efi-libdir=${gnu-efi}/lib"
    "--with-efi-ldsdir=${gnu-efi}/lib"
  ];

  src = fetchurl {
    url = http://pkgs.fedoraproject.org/repo/pkgs/gummiboot/gummiboot-45.tar.xz/5d4957390e959cb9f325b87712ddd3f1/gummiboot-45.tar.xz;
    md5 = "5d4957390e959cb9f325b87712ddd3f1";
  };

  meta = {
    description = "A simple UEFI boot manager which executes configured EFI images";

    homepage = http://freedesktop.org/wiki/Software/gummiboot;

    license = stdenv.lib.licenses.lgpl21Plus;

    platforms = [ "x86_64-linux" "i686-linux" ];

    maintainers = [ stdenv.lib.maintainers.shlevy ];
  };
}
