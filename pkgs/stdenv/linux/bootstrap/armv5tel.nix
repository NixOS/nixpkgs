{
  busybox = import <nix/fetchurl.nix> {
    url = http://nixos-arm.dezgeg.me/bootstrap-2016-07-20-33a1d8/armv5tel/busybox;
    sha256 = "03i90dwkly1j2a7i12qixkybjz2b24ixjrl7zsr17s1sv6m27zba";
    executable = true;
  };

  bootstrapTools = import <nix/fetchurl.nix> {
    url = http://nixos-arm.dezgeg.me/bootstrap-2016-07-20-33a1d8/armv5tel/bootstrap-tools.tar.xz;
    sha256 = "1sikiydjlbv8v35fgjvr5swgvj6bc83gmrbjrhpi0hyzyfcinxbn";
  };
}
