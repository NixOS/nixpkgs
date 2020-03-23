{
  # Note: do not use Hydra as a source URL. Ask a member of the
  # infrastructure team to mirror the job.
  busybox = import <nix/fetchurl.nix> {
    # from job: https://hydra.nixos.org/job/nixpkgs/cross-trunk/bootstrapTools.armv5tel.dist/latest
    # from build: https://hydra.nixos.org/build/114203025
    url = "http://tarballs.nixos.org/stdenv-linux/armv5tel/0eb0ddc4dbe3cd5415c6b6e657538eb809fc3778/busybox";
    # note: the following hash is different than the above hash, due to executable = true
    sha256 = "0qxp2fsvs4phbc17g9npj9bsm20ylr8myi5pivcrmxm5qqflgi8d";
    executable = true;
  };
  bootstrapTools = import <nix/fetchurl.nix> {
    # from job: https://hydra.nixos.org/job/nixpkgs/cross-trunk/bootstrapTools.armv5tel.dist/latest
    # from build: https://hydra.nixos.org/build/114203025
    url = "http://tarballs.nixos.org/stdenv-linux/armv5tel/0eb0ddc4dbe3cd5415c6b6e657538eb809fc3778/bootstrap-tools.tar.xz";
    sha256 = "28327343db5ecc7f7811449ec69280d5867fa5d1d377cab0426beb9d4e059ed6";
  };
}
