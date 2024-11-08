{ lib, stdenv, callPackage, fuse-t, fetchpatch, fuse3 }:

let mkSSHFS = args: callPackage (import ./common.nix args) { };
in if stdenv.hostPlatform.isDarwin then
  mkSSHFS {
    version = "2.10"; # FUSE-T isn't yet compatible with libfuse 3.x
    sha256 = "1dmw4kx6vyawcywiv8drrajnam0m29mxfswcp4209qafzx3mjlp1";
    fuse = fuse-t;
    patches = [
      # remove reference to fuse_darwin.h which doesn't exist on newer macFUSE or FUSE-T
      ./fix-fuse-darwin-h.patch

      # From https://github.com/libfuse/sshfs/pull/185:
      # > With this patch, setting I/O size to a reasonable large value, will
      # > result in much improved performance, e.g.: -o iosize=1048576
      (fetchpatch {
        name = "fix-configurable-blksize.patch";
        url = "https://github.com/libfuse/sshfs/commit/667cf34622e2e873db776791df275c7a582d6295.patch";
        sha256 = "0d65lawd2g2aisk1rw2vl65dgxywf4vqgv765n9zj9zysyya8a54";
      })

      ./support-fuse-t.patch
    ];
    platforms = lib.platforms.darwin;
  }
else
  mkSSHFS {
    version = "3.7.3";
    sha256 = "0s2hilqixjmv4y8n67zaq374sgnbscp95lgz5ignp69g3p1vmhwz";
    fuse = fuse3;
    platforms = lib.platforms.linux;
  }
