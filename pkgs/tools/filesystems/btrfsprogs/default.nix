{ stdenv, fetchurl, attr, acl, zlib, libuuid, e2fsprogs, lzo
, asciidoc, xmlto, docbook_xml_dtd_45, docbook_xsl, libxslt }:

let version = "3.18"; in

stdenv.mkDerivation rec {
  name = "btrfs-progs-${version}";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/people/kdave/btrfs-progs/btrfs-progs-v${version}.tar.xz";
    sha256 = "0k84c6gxgy5sq8m57nfjd864s5hps3fh7zgyiykiqik65l5sp97r";
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
