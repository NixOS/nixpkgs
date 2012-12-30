{ stdenv, fetchgit, zlib, libuuid, acl, attr, e2fsprogs }:

let version = "0.20pre20121005"; in

stdenv.mkDerivation {
  name = "btrfs-progs-${version}";

  src = fetchgit {
    url = "git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-progs.git";
    rev = "91d9eec1ff044394f2b98ee7fcb76713dd33b994";
    sha256 = "72d4cd4fb23d876a17146d6231ad40a2151fa47c648485c54cf7478239b43764";
  };

  patches = [
    ./subvol-listing.patch
    ./btrfs-receive-help-text.patch
    ./btrfs-progs-Fix-the-receive-code-pathing.patch
    ./btrfs-receive-lchown.patch
  ];

  buildInputs = [ zlib libuuid acl attr e2fsprogs ];

  makeFlags = "prefix=$(out)";

  meta = {
    description = "Utilities for the btrfs filesystem";
    homepage = https://btrfs.wiki.kernel.org/;
    maintainers = [ stdenv.lib.maintainers.raskin ];
    platforms = stdenv.lib.platforms.linux;
  };
}
