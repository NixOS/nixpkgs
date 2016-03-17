{
  busybox = import <nix/fetchurl.nix> {
    url = http://nixos-arm.dezgeg.me/bootstrap/armv6l/busybox;
    sha256 = "12hij075qapim3jaqc8rb2rvjdradc4937i9mkfa27b6ly1injs0";
    executable = true;
  };

  bootstrapTools = import <nix/fetchurl.nix> {
    url = http://nixos-arm.dezgeg.me/bootstrap/armv6l/bootstrap-tools.tar.xz;
    sha256 = "14irgvw2wl2ljqbmdislhw3nakmx6wmlm1xki26rk20q2ciic2il";
  };
}
