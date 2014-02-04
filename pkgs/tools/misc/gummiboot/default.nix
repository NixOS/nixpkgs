{ stdenv, fetchurl, gnu-efi, unzip, pkgconfig, utillinux, libxslt, docbook_xsl, docbook_xml_dtd_42 }:

stdenv.mkDerivation rec {
  name = "gummiboot-43";

  buildInputs = [ gnu-efi pkgconfig libxslt utillinux ];

  # Sigh, gummiboot should be able to find this in buildInputs
  configureFlags = [
    "--with-efi-includedir=${gnu-efi}/include"
    "--with-efi-libdir=${gnu-efi}/lib"
    "--with-efi-ldsdir=${gnu-efi}/lib"
  ];

  src = fetchurl {
    url = http://pkgs.fedoraproject.org/repo/pkgs/gummiboot/gummiboot-43.tar.xz/c9b46a3504a2f7e335404a1475818d98/gummiboot-43.tar.xz;
    sha256 = "1hwaan3985ap9r5ncf9bykbaixbm0xn4x09silssngwfl2srn4iv";
  };

  meta = {
    description = "A simple UEFI boot manager which executes configured EFI images";

    homepage = http://freedesktop.org/wiki/Software/gummiboot;

    license = stdenv.lib.licenses.lgpl21Plus;

    platforms = [ "x86_64-linux" "i686-linux" ];

    maintainers = [ stdenv.lib.maintainers.shlevy ];
  };
}
