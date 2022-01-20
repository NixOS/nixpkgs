{
  busybox = import <nix/fetchurl.nix> {
    url = "http://tarballs.nixos.org/stdenv-linux/aarch64/c7c997a0662bf88264db52cbc41e67884eb7a1ff/busybox";
    sha256 = "sha256-4EN2vLvXUkelZZR2eKaAQA5kCEuHNvRZN6dcohxVY+c=";
    executable = true;
  };
  bootstrapTools = import <nix/fetchurl.nix> {
    url = "http://tarballs.nixos.org/stdenv-linux/aarch64/c7c997a0662bf88264db52cbc41e67884eb7a1ff/bootstrap-tools.tar.xz";
    sha256 = "sha256-AjOvmaW8JFVZaBSRUMKufr9kJozg/tsZr7PvUEBQyi4=";
  };
}
