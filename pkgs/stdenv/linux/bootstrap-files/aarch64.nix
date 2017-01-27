{
  busybox = import <nix/fetchurl.nix> {
    url = http://nixos-arm.dezgeg.me/bootstrap-aarch64-for-merge/busybox;
    sha256 = "12qcml1l67skpjhfjwy7gr10nc86gqcwjmz9ggp7knss8gq8pv7f";
    executable = true;
  };
  bootstrapTools = import <nix/fetchurl.nix> {
    url = http://nixos-arm.dezgeg.me/bootstrap-aarch64-for-merge/bootstrap-tools.tar.xz;
    sha256 = "10sqgh0dchp1906h06jznxh8gfflnzbpfy27hng2mmc1l0c7irjr";
  };
}
