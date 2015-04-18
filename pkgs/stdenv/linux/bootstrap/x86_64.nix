# Use busybox for i686-linux since it works on x86_64-linux as well.
(import ./i686.nix) //

{
  bootstrapTools = import <nix/fetchurl.nix> {
    url = http://tarballs.nixos.org/stdenv-linux/x86_64/8d66a51a872af1ab58edc68a2ebddcc79958b563/bootstrap-tools.tar.xz;
    sha256 = "325230b74d3d98f62ddcb595543887d09cd8421745a4eda229d2a87a1f1ed336";
  };
}
