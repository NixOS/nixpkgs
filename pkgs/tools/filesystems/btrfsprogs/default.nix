{ stdenv, fetchurl, attr, acl, zlib, libuuid, e2fsprogs, lzo
, asciidoc, xmlto, docbook_xml_dtd_45, docbook_xsl, libxslt }:

let version = "3.14.2"; in

stdenv.mkDerivation rec {
  name = "btrfs-progs-${version}";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/people/mason/btrfs-progs/btrfs-progs-v${version}.tar.xz";
    sha256 = "14vpj6f2v076v9zabgrz8l4dp6n1ar2mvk3lvii51ykvi35d1qbh";
  };

  buildInputs = [
    attr acl zlib libuuid e2fsprogs lzo
    asciidoc xmlto docbook_xml_dtd_45 docbook_xsl libxslt
  ];

  # for btrfs to get the rpath to libgcc_s, needed for pthread_cancel to work
  NIX_CFLAGS_LINK = "-lgcc_s";

  makeFlags = "prefix=$(out)";

  meta = {
    description = "Utilities for the btrfs filesystem";
    homepage = https://btrfs.wiki.kernel.org/;
    maintainers = [ stdenv.lib.maintainers.raskin ];
    platforms = stdenv.lib.platforms.linux;
  };
}
