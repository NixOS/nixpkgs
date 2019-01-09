{ stdenv, fetchurl, fetchpatch, pkgconfig, attr, acl, zlib, libuuid, e2fsprogs, lzo
, asciidoc, xmlto, docbook_xml_dtd_45, docbook_xsl, libxslt, zstd, python3, python3Packages
}:

stdenv.mkDerivation rec {
  name = "btrfs-progs-${version}";
  version = "4.19.1";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/people/kdave/btrfs-progs/btrfs-progs-v${version}.tar.xz";
    sha256 = "1f7gpk9206ph081fr0af8k57i58zjb03xwd8k69177a7rzsjmn04";
  };

  nativeBuildInputs = [
    pkgconfig asciidoc xmlto docbook_xml_dtd_45 docbook_xsl libxslt python3 python3Packages.setuptools
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
