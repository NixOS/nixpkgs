{
  busybox = import <nix/fetchurl.nix> {
    url = "http://tarballs.nixos.org/stdenv-linux/riscv64/9bd3cf0063b80428bd85a286205adab4b6ffcbd6/busybox";
    sha256 = "6f61912f94bc4ef287d1ff48a9521ed16bd07d8d8ec775e471f32c64d346583d";
    executable = true;
  };

  bootstrapTools = import <nix/fetchurl.nix> {
    url = "http://tarballs.nixos.org/stdenv-linux/riscv64/9bd3cf0063b80428bd85a286205adab4b6ffcbd6/bootstrap-tools.tar.xz";
    sha256 = "5466b19288e980125fc62ebb864d09908ffe0bc50cebe52cfee89acff14d5b9f";
  };
}
