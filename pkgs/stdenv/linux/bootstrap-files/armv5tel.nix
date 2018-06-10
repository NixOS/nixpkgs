{
  busybox = import <nix/fetchurl.nix> {
    url = http://nixos-arm.dezgeg.me/bootstrap-2017-04-13-1f32d4b4/armv5tel/busybox;
    sha256 = "00mxas5xg2j9n1g0q0nklr0dy87qqxk0jja5qz1yi7xl7zzsnpnw";
    executable = true;
  };

  bootstrapTools = import <nix/fetchurl.nix> {
    url = http://nixos-arm.dezgeg.me/bootstrap-2017-04-13-1f32d4b4/armv5tel/bootstrap-tools.tar.xz;
    sha256 = "0fhiy9l3mbmlhpkby31c2s63bhjiqx25qqr3wdp8cb7fxz8ayx2f";
  };
}
