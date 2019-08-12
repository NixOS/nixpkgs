{
  busybox = import <nix/fetchurl.nix> {
    url = https://lblasc-nix-dev.s3-eu-west-1.amazonaws.com/bootstrap-tools-i686-gcc9/busybox;
    sha256 = "03g3hz2ar6nz7chfwip72gvy4wd828ha9bdgg6mjs9llsc0d2izz";
    executable = true;
  };

  bootstrapTools = import <nix/fetchurl.nix> {
    url = https://lblasc-nix-dev.s3-eu-west-1.amazonaws.com/bootstrap-tools-i686-gcc9/bootstrap-tools.tar.xz;
    sha256 = "1m142s2z7v3v6k0m3d91prp7i71hhy394jgnkd7y3z5sh15c8j28";
  };
}
