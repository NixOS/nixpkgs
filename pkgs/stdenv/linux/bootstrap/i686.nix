{
  busybox = import <nix/fetchurl.nix> {
    url = http://tarballs.nixos.org/stdenv-linux/i686/ac8e5cd145fa5f22bab1b01d8b4db4d26d22e65c/busybox;
    sha256 = "0314dskcp6gp0jpy87phpjz1r13zh0grb40yvdl9s4l2rxzgzr2v";
    executable = true;
  };

  bootstrapTools = import <nix/fetchurl.nix> {
    url = http://tarballs.nixos.org/stdenv-linux/i686/ac8e5cd145fa5f22bab1b01d8b4db4d26d22e65c/bootstrap-tools.tar.xz;
    sha256 = "025r3vifkqlw0i5nvlkmfrvbn0v73r1pr6jkqckgs585y7nmsjhz";
  };
}
