{ stdenv, fetchgit, zlib, libuuid, acl, attr, e2fsprogs }:

let version = "0.19-20120328"; in

stdenv.mkDerivation {
  name = "btrfs-progs-${version}";

  src = fetchgit {
    url = "git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-progs.git";
    rev = "1957076ab4fefa47b6efed3da541bc974c83eed7";
    sha256 = "566d863c5500652e999d0d6b823365fb06f2f8f9523e65e69eaa3e993e9b26e1";
  };

  buildInputs = [ zlib libuuid acl attr e2fsprogs ];

  makeFlags = "prefix=$(out)";

  meta = {
    description = "Utilities for the btrfs filesystem";
    homepage = https://btrfs.wiki.kernel.org/;
    maintainers = [ stdenv.lib.maintainers.raskin ];
    platforms = stdenv.lib.platforms.linux;
  };
}
