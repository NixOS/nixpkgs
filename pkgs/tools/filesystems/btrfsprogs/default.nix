{ stdenv, fetchurl, attr, acl, zlib, libuuid, e2fsprogs, lzo }:

let version = "3.14"; in

stdenv.mkDerivation rec {
  name = "btrfs-progs-${version}";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/people/mason/btrfs-progs/btrfs-progs-v${version}.tar.xz";
    sha256 = "1qjy4bc96nfzkdjp6hwb85aasqs87nkmgi8pl6qa6cpvml3627cq";
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
  };
}
