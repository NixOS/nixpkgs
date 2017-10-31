{
  busybox = import <nix/fetchurl.nix> {
    url = http://nixos-arm.dezgeg.me/bootstrap-aarch64-2017-03-11-bb3ef8/busybox;
    sha256 = "12qcml1l67skpjhfjwy7gr10nc86gqcwjmz9ggp7knss8gq8pv7f";
    executable = true;
  };
  bootstrapTools = import <nix/fetchurl.nix> {
    url = http://nixos-arm.dezgeg.me/bootstrap-aarch64-2017-03-11-bb3ef8/bootstrap-tools.tar.xz;
    sha256 = "1075d5n4yclbhgisi6ba50601mw3fhivlkjs462qlnq8hh0xc7nq";
  };
}
