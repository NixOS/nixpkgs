{ stdenv, fetchurl, pkgconfig, attr, acl, zlib, libuuid, e2fsprogs, lzo
, asciidoc, xmlto, docbook_xml_dtd_45, docbook_xsl, libxslt
}:

let version = "4.8.2"; in

stdenv.mkDerivation rec {
  name = "btrfs-progs-${version}";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/people/kdave/btrfs-progs/btrfs-progs-v${version}.tar.xz";
    sha256 = "0pswcfmdnfc586770h74abp67gn2xv8fd46vxlimnmn837sj7h41";
  };

  buildInputs = [
    pkgconfig attr acl zlib libuuid e2fsprogs lzo
    asciidoc xmlto docbook_xml_dtd_45 docbook_xsl libxslt
  ];

  # gcc bug with -O1 on ARM with gcc 4.8
  # This should be fine on all platforms so apply universally
  patchPhase = "sed -i s/-O1/-O2/ configure";

  postInstall = ''
    install -v -m 444 -D btrfs-completion $out/etc/bash_completion.d/btrfs
  '';

  meta = with stdenv.lib; {
    description = "Utilities for the btrfs filesystem";
    homepage = https://btrfs.wiki.kernel.org/;
    license = licenses.gpl2;
    maintainers = with maintainers; [ nckx raskin wkennington ];
    platforms = platforms.linux;
  };
}
