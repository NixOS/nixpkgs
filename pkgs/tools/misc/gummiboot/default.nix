{ stdenv, fetchurl, gnu-efi, unzip, pkgconfig, utillinux, libxslt, docbook_xsl, docbook_xml_dtd_42 }:

stdenv.mkDerivation rec {
  name = "gummiboot-38";

  buildInputs = [ gnu-efi pkgconfig libxslt utillinux ];

  # Sigh, gummiboot should be able to find this in buildInputs
  configureFlags = [
    "--with-efi-includedir=${gnu-efi}/include"
    "--with-efi-libdir=${gnu-efi}/lib"
    "--with-efi-ldsdir=${gnu-efi}/lib"
  ];

  src = fetchurl {
    url = http://pkgs.fedoraproject.org/repo/pkgs/gummiboot/gummiboot-38.tar.xz/0504791387e1998bf2075728c237f27e/gummiboot-38.tar.xz;
    sha256 = "1aid2a29ym8dqldxpcihnrls7vrr9ijbla3dad0r8qwkca43d4lm";
  };

  meta = {
    description = "A simple UEFI boot manager which executes configured EFI images";

    homepage = http://freedesktop.org/wiki/Software/gummiboot;

    license = stdenv.lib.licenses.lgpl21Plus;

    platforms = [ "x86_64-linux" "i686-linux" ];

    maintainers = [ stdenv.lib.maintainers.shlevy ];
  };
}
