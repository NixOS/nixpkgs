{
  busybox = import <nix/fetchurl.nix> {
    url = http://nixos-arm.dezgeg.me/bootstrap-2017-04-13-1f32d4b4/armv7l/busybox;
    sha256 = "187xwzsng5lpak1nanrk88y4mlydmrbhx6la00rrd6kjx376s565";
    executable = true;
  };

  bootstrapTools = import <nix/fetchurl.nix> {
    url = http://nixos-arm.dezgeg.me/bootstrap-2017-04-13-1f32d4b4/armv7l/bootstrap-tools.tar.xz;
    sha256 = "05ayki2kak3i5lw97qidd5h9jv00dmlhx9h7l771bj331yamyqdn";
  };
}
