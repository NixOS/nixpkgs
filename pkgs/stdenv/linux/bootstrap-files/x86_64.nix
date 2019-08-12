# Use busybox for i686-linux since it works on x86_64-linux as well.
(import ./i686.nix) //

{
  bootstrapTools = import <nix/fetchurl.nix> {
    url = https://lblasc-nix-dev.s3-eu-west-1.amazonaws.com/bootstrap-tools-x86-64-gcc9/bootstrap-tools.tar.xz;
    sha256 = "0dyvaqlaszd5i2vr36h4d3k47a5xc550n1y4mkiirm1gd4ynaz1g";
  };
}
