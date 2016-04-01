{
  busybox = import <nix/fetchurl.nix> {
    url = http://nixos-arm.dezgeg.me/bootstrap/armv5tel/busybox;
    sha256 = "1jdwznkgbkmz0zy58idgrm6prpw8x8wis14dxkxwzbzk7g1l3a2x";
    executable = true;
  };

  bootstrapTools = import <nix/fetchurl.nix> {
    url = http://nixos-arm.dezgeg.me/bootstrap/armv5tel/bootstrap-tools.tar.xz;
    sha256 = "10rjp7mv6cfh9n2wfifdlaak8wqcmcpmylhn8jn0430ap37qqhb0";
  };
}
