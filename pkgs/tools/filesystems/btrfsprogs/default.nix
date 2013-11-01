{ stdenv, fetchgit, zlib, libuuid, acl, attr, e2fsprogs, lzo }:

let version = "0.20pre20130705"; in

stdenv.mkDerivation {
  name = "btrfs-progs-${version}";

  src = fetchgit {
    url = "git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-progs.git";
    rev = "194aa4a1bd6447bb545286d0bcb0b0be8204d79f";
    sha256 = "07c6762c9873cdcc1b9b3be0b412ba14b83457d8f5608d3dd945953b5e06f0f2";
  };

  buildInputs = [ zlib libuuid acl attr e2fsprogs lzo ];

  # for btrfs to get the rpath to libgcc_s, needed for pthread_cancel to work
  NIX_CFLAGS_LINK = "-lgcc_s";

  postPatch = ''
    cp ${./btrfs-set-received-uuid.c} btrfs-set-received-uuid.c
  '';

  postBuild = ''
    gcc -Wall -D_FILE_OFFSET_BITS=64 -U_FORTIFY_SOURCE -D_FORTIFY_SOURCE=2 -DBTRFS_FLAT_INCLUDES \
        -fPIC -g -O1 -luuid -o btrfs-set-received-uuid rbtree.o send-utils.o btrfs-list.o \
        btrfs-set-received-uuid.c
  '';

  postInstall = ''
    cp btrfs-set-received-uuid $out/bin
  '';

  makeFlags = "prefix=$(out)";

  meta = {
    description = "Utilities for the btrfs filesystem";
    homepage = https://btrfs.wiki.kernel.org/;
    maintainers = [ stdenv.lib.maintainers.raskin ];
    platforms = stdenv.lib.platforms.linux;
  };
}
