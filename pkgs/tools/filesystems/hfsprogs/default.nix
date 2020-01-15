{ stdenv, fetchurl, fetchpatch, openssl, libbsd, libuuid }:

stdenv.mkDerivation rec {
  pname = "hfsprogs";
  version = "540.1.linux3";
  srcs = [
    (fetchurl {
      url = "http://cavan.codon.org.uk/~mjg59/diskdev_cmds/diskdev_cmds-${version}.tar.gz";
      sha256 = "15sl9z1dafykj3b249z6a82p74ljqpgkvh97l0vbz8zrjwx206xh";
    })
  ];

  sourceRoot = "diskdev_cmds-" + version;
  patches = [
    (fetchpatch {
      url = "https://src.fedoraproject.org/rpms/hfsplus-tools/raw/6eec8fe28f8aaaa895d4e30fa06397ec7403fd7f/f/hfsplus-tools-no-blocks.patch";
      sha256 = "13lz7rr2ydwcxl7vvc0rf563clfkvq1ngism3xf25f7ispi0y6xx";
    })
    (fetchpatch {
      url = "https://src.fedoraproject.org/rpms/hfsplus-tools/raw/6eec8fe28f8aaaa895d4e30fa06397ec7403fd7f/f/hfsplus-tools-learn-to-stdarg.patch";
      sha256 = "1gsqxmk5piq73d7mykccmapnls1fb865njjz9pk4fkhifvdmpjss";
    })

  ];

  buildInputs = [ openssl libbsd libuuid ];

  postPatch = ''
    # Fixup man pages to match install utilitied names
    sed -i -e 's/[F|f]sck_hfs/fsck.hfsplus/g' fsck_hfs.tproj/fsck_hfs.8
    sed -i -e 's/[N|n]ewfs_hfs/mkfs.hfsplus/g' newfs_hfs.tproj/newfs_hfs.8

    # Remove errant execute bits.
    find . -type f -name '*.[ch]' -exec chmod -c -x {} +
  '';

  # Inspired by Arch and Fedora's very similar installation snippets
  # Note fsck util works for both hfs and hfsplus, but mkfs only for hfsplus.
  installPhase = ''
    # Copy executables
    install -Dm755 newfs_hfs.tproj/newfs_hfs $out/bin/mkfs.hfsplus
    install -Dm755 fsck_hfs.tproj/fsck_hfs $out/bin/fsck.hfsplus
    ln -sr $out/bin/fsck.hfsplus $out/bin/fsck.hfs

    # Copy man pages
    install -Dm644 newfs_hfs.tproj/newfs_hfs.8 $out/share/man/man8/mkfs.hfsplus.8
    install -Dm644 fsck_hfs.tproj/fsck_hfs.8 $out/share/man/man8/fsck.hfsplus.8
    ln -sr $out/share/man/man8/fsck.hfsplus.8 $out/share/man/man8/fsck.hfs.8
  '';

  meta = {
    description = "Tools to create/check Apple HFS+ filesystems";
    homepage = "https://src.fedoraproject.org/rpms/hfsplus-tools";
    license = stdenv.lib.licenses.apsl20;
    platforms = stdenv.lib.platforms.linux;
  };
}
