{ stdenv, fetchurl, attr, acl, zlib, libuuid, e2fsprogs, lzo
, asciidoc, xmlto, docbook_xml_dtd_45, docbook_xsl, libxslt }:

let version = "3.16"; in

stdenv.mkDerivation rec {
  name = "btrfs-progs-${version}";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/people/kdave/btrfs-progs/btrfs-progs-v${version}.tar.xz";
    sha256 = "0phbrgipl04q8cdj9nnshik7b6p2bg51jxb3l1gvfc04dkgm2xls";
  };

  buildInputs = [
    attr acl zlib libuuid e2fsprogs lzo
    asciidoc xmlto docbook_xml_dtd_45 docbook_xsl libxslt
  ];

  # for btrfs to get the rpath to libgcc_s, needed for pthread_cancel to work
  NIX_CFLAGS_LINK = "-lgcc_s";

  makeFlags = "prefix=$(out)";

  meta = with stdenv.lib; {
    description = "Utilities for the btrfs filesystem";
    homepage = https://btrfs.wiki.kernel.org/;
    license = licenses.gpl2;
    maintainers = with maintainers; [ raskin wkennington ];
    platforms = platforms.linux;
  };
}
