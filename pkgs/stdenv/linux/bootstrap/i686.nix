{
  busybox = import <nix/fetchurl.nix> {
    url = http://tarballs.nixos.org/stdenv-linux/i686/73b75f6157db79fc899154a497823e82e409e76d/busybox;
    sha256 = "159208615405938d9830634f15d38adf5a9c33643926845c44499dbe6dd62042";
    executable = true;
  };

  bootstrapTools = import <nix/fetchurl.nix> {
    url = http://tarballs.nixos.org/stdenv-linux/i686/73b75f6157db79fc899154a497823e82e409e76d/bootstrap-tools.tar.xz;
    sha256 = "68c430b84dbeac0bd1bea4cdd3159dce44a76445e07860caed1972b4608c42ca";
  };
}
