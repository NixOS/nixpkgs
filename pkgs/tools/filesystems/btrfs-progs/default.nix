{ stdenv, fetchurl, pkgconfig, attr, acl, zlib, libuuid, e2fsprogs, lzo
, asciidoc, xmlto, docbook_xml_dtd_45, docbook_xsl, libxslt, zstd, python3
}:

stdenv.mkDerivation rec {
  pname = "btrfs-progs";
  version = "5.9";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/people/kdave/btrfs-progs/btrfs-progs-v${version}.tar.xz";
    sha256 = "14d7hz07kfczfgmy1ixkgccjn393gpkjn7givz5kwxddcnk5i4xq";
  };

  nativeBuildInputs = [
    pkgconfig asciidoc xmlto docbook_xml_dtd_45 docbook_xsl libxslt
    python3 python3.pkgs.setuptools
  ];

  buildInputs = [ attr acl zlib libuuid e2fsprogs lzo zstd python3 ];

  # for python cross-compiling
  _PYTHON_HOST_PLATFORM = stdenv.hostPlatform.config;

  # gcc bug with -O1 on ARM with gcc 4.8
  # This should be fine on all platforms so apply universally
  postPatch = "sed -i s/-O1/-O2/ configure";

  postInstall = ''
    install -v -m 444 -D btrfs-completion $out/etc/bash_completion.d/btrfs
  '';

  configureFlags = stdenv.lib.optional stdenv.hostPlatform.isMusl "--disable-backtrace";

  meta = with stdenv.lib; {
    description = "Utilities for the btrfs filesystem";
    homepage = "https://btrfs.wiki.kernel.org/";
    license = licenses.gpl2;
    maintainers = with maintainers; [ raskin ];
    platforms = platforms.linux;
  };
}
