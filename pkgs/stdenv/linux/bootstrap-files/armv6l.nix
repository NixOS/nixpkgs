{
  busybox = import <nix/fetchurl.nix> {
    url = https://hydra.nixos.org/build/112609441/download/2/busybox;
    sha256 = "e6f6aecb675e924a96516f4379445dd2c0ba8b9c438fbfbaa2dc14ccce2802e0";
    executable = true;
  };

  bootstrapTools = import <nix/fetchurl.nix> {
    url = https://hydra.nixos.org/build/112609441/download/1/bootstrap-tools.tar.xz;
    sha256 = "7a3f20def1a17ebf0edb5a92c403558429bcc2ac3d931b5e1bd88606cb217778";
  };
}
