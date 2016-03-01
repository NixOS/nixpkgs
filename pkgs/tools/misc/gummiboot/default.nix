{ stdenv, fetchurl, gnu-efi, unzip, pkgconfig, utillinux, libxslt, docbook_xsl, docbook_xml_dtd_42 }:

stdenv.mkDerivation rec {
  name = "gummiboot-48";

  buildInputs = [ gnu-efi pkgconfig libxslt utillinux ];

  hardening_stackprotector = false;

  # Sigh, gummiboot should be able to find this in buildInputs
  configureFlags = [
    "--with-efi-includedir=${gnu-efi}/include"
    "--with-efi-libdir=${gnu-efi}/lib"
    "--with-efi-ldsdir=${gnu-efi}/lib"
  ];

  src = fetchurl {
    url = http://pkgs.fedoraproject.org/repo/pkgs/gummiboot/gummiboot-48.tar.xz/05ef3951e8322b76c31f2fd14efdc185/gummiboot-48.tar.xz;
    sha256 = "1bzygyglgglhb3aj77w2qcb0dz9sxgb7lq5krxf6417431h198rg";
  };

  meta = {
    description = "A simple UEFI boot manager which executes configured EFI images";

    homepage = http://freedesktop.org/wiki/Software/gummiboot;

    license = stdenv.lib.licenses.lgpl21Plus;

    platforms = [ "x86_64-linux" "i686-linux" ];
  };
}
