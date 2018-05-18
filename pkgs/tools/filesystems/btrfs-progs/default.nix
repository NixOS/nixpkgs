{ stdenv, fetchurl, fetchpatch, pkgconfig, attr, acl, zlib, libuuid, e2fsprogs, lzo
, asciidoc, xmlto, docbook_xml_dtd_45, docbook_xsl, libxslt, zstd
}:

stdenv.mkDerivation rec {
  name = "btrfs-progs-${version}";
  version = "4.15.1";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/people/kdave/btrfs-progs/btrfs-progs-v${version}.tar.xz";
    sha256 = "15izak6jg6pqr6ha9447cdrdj9k6kfiarvwlrj53cpvrsv02l437";
  };

  patches = [
    # Fix build with e2fsprogs 1.44.0
    (fetchpatch {
      url = "https://patchwork.kernel.org/patch/10281327/raw/";
      sha256 = "016124hjms220809zjvvr7l1gq23j419d3piaijsaw8n7yd3kksf";
    })
  ];

  nativeBuildInputs = [
    pkgconfig asciidoc xmlto docbook_xml_dtd_45 docbook_xsl libxslt
  ];

  buildInputs = [ attr acl zlib libuuid e2fsprogs lzo zstd ];

  # gcc bug with -O1 on ARM with gcc 4.8
  # This should be fine on all platforms so apply universally
  postPatch = "sed -i s/-O1/-O2/ configure";

  postInstall = ''
    install -v -m 444 -D btrfs-completion $out/etc/bash_completion.d/btrfs
  '';

  configureFlags = stdenv.lib.optional stdenv.hostPlatform.isMusl "--disable-backtrace";

  meta = with stdenv.lib; {
    description = "Utilities for the btrfs filesystem";
    homepage = https://btrfs.wiki.kernel.org/;
    license = licenses.gpl2;
    maintainers = with maintainers; [ raskin wkennington ];
    platforms = platforms.linux;
  };
}
