# Use busybox for i686-linux since it works on x86_64-linux as well.
(import ./i686.nix) //

{
  bootstrapTools = import <nix/fetchurl.nix> {
    url = http://tarballs.nixos.org/stdenv-linux/x86_64/4907fc9e8d0d82b28b3c56e3a478a2882f1d700f/bootstrap-tools.tar.xz;
    sha256 = "abe3f0727dd771a60b7922892d308da1bc7b082afc13440880862f0c8823c09f";
  };
}
