{ stdenv, fetchgit, zlib, libuuid, acl, attr, e2fsprogs, lzo }:

let version = "0.20pre20130509"; in

stdenv.mkDerivation {
  name = "btrfs-progs-${version}";

  src = fetchgit {
    url = "git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-progs.git";
    rev = "650e656a8b9c1fbe4ec5cd8c48ae285b8abd3b69";
    sha256 = "e50e8ce9d24505711ed855f69a73d639dc5e401692a7d1c300753de3472abb21";
  };

  buildInputs = [ zlib libuuid acl attr e2fsprogs lzo ];

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
