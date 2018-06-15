{
  busybox = import <nix/fetchurl.nix> {
    url = http://nixos-arm.dezgeg.me/bootstrap-2017-04-13-1f32d4b4/armv6l/busybox;
    sha256 = "06n8dy8y2v28yx9ws8x64wxrvn9pszgpd299hc90nv9x21m79jzd";
    executable = true;
  };

  bootstrapTools = import <nix/fetchurl.nix> {
    url = http://nixos-arm.dezgeg.me/bootstrap-2017-04-13-1f32d4b4/armv6l/bootstrap-tools.tar.xz;
    sha256 = "1gg2q3sw81vi65g1gmpvx0nnd6hxb76vlz73wfp292m90z1mym7f";
  };
}
