{
  busybox = import <nix/fetchurl.nix> {
    url = http://nixos-arm.dezgeg.me/bootstrap-2016-07-20-33a1d8/armv7l/busybox;
    sha256 = "0kb439p37rzlascp6ldm4kwf5kwd6p3lv17c41zwj20wbv8sdilq";
    executable = true;
  };

  bootstrapTools = import <nix/fetchurl.nix> {
    url = http://nixos-arm.dezgeg.me/bootstrap-2016-07-20-33a1d8/armv7l/bootstrap-tools.tar.xz;
    sha256 = "0h75xbpkyzhvmjzhj9i598p0cq60py7v0b8lryrvcqw7qjlbgrsd";
  };
}
