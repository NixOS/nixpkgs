{ stdenv, fetchurl, docbook2x, docbook_sgml_dtd_41 }:

assert (stdenv.lib.elem stdenv.system stdenv.lib.platforms.linux);

stdenv.mkDerivation {
  name = "module-init-tools-3.16";

  src = [
    (fetchurl {
      url = http://ftp.be.debian.org/pub/linux/utils/kernel/module-init-tools/module-init-tools-3.16.tar.bz2;
      sha256 = "0jxnz9ahfic79rp93l5wxcbgh4pkv85mwnjlbv1gz3jawv5cvwp1";
    })

    # Upstream forgot to include the generated manpages.  Thankfully
    # the Gentoo people fixed this for us :-)
    (fetchurl {
      urls = [
        mirror://gentoo/distfiles/module-init-tools-3.16-man.tar.bz2
        http://mirror.meleeweb.net/pub/linux/gentoo/distfiles/module-init-tools-3.16-man.tar.bz2
      ];
      sha256 = "1j1nzi87kgsh4scl645fhwhjvljxj83cmdasa4n4p5krhasgw358";
    })
  ];

  buildInputs = [ stdenv.glibc.dev stdenv.glibc.static ];

  SGML_CATALOG_FILES = "${docbook_sgml_dtd_41}/sgml/dtd/docbook-4.1/docbook.cat";

  patches = [ ./module-dir.patch ./docbook2man.patch ];

  postInstall = "rm $out/sbin/insmod.static"; # don't need it

  meta = {
    homepage = http://www.kernel.org/pub/linux/utils/kernel/module-init-tools/;
    description = "Tools for loading and managing Linux kernel modules";
    platforms = stdenv.lib.platforms.linux;
  };
}
