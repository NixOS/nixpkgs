{ stdenv, fetchurl, attr, acl, zlib, libuuid, e2fsprogs, lzo }:

stdenv.mkDerivation rec {
  name = "btrfs-progs-${meta.version}";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/people/mason/btrfs-progs/btrfs-progs-v${meta.version}.tar.xz";
    sha256 = "1pwcjf9jqdiy8445r1xkazqa07xmapnn0ylyz7yzphci3ib66zh9";
  };

  buildInputs = [ attr acl zlib libuuid e2fsprogs lzo ];

  # for btrfs to get the rpath to libgcc_s, needed for pthread_cancel to work
  NIX_CFLAGS_LINK = "-lgcc_s";

  makeFlags = "prefix=$(out)";

  meta = {
    description = "Utilities for the btrfs filesystem";
    homepage = https://btrfs.wiki.kernel.org/;
    maintainers = [ stdenv.lib.maintainers.raskin ];
    platforms = stdenv.lib.platforms.linux;
    version="3.12";
  };
}
