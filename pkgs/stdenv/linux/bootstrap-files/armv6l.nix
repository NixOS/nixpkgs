{
  busybox = import <nix/fetchurl.nix> {
    url = http://nixos-arm.dezgeg.me/bootstrap-2016-07-20-33a1d8/armv6l/busybox;
    sha256 = "1vl1nx7ccalp2w8d5ymj6i2vs0s9w80xvxpsxl2l24k5ibbspcy0";
    executable = true;
  };

  bootstrapTools = import <nix/fetchurl.nix> {
    url = http://nixos-arm.dezgeg.me/bootstrap-2016-07-20-33a1d8/armv6l/bootstrap-tools.tar.xz;
    sha256 = "106f3r1ndl9h1cbxn44vwn3kkhgi8a937xx1v9n40zfx6dzzfv25";
  };
}
