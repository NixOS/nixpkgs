{
  busybox = import <nix/fetchurl.nix> {
    url = https://wdtz.org/files/m4n9p43b7q8k1wqbpw264947rm70mj1z-stdenv-bootstrap-tools-armv6l-unknown-linux-musleabihf/on-server/busybox;
    sha256 = "01d0hp1xgrriiy9w0sd9vbqzwxnpwiyah80pi4vrpcmbwji36j1i";
    executable = true;
  };
  bootstrapTools = import <nix/fetchurl.nix> {
    url = https://wdtz.org/files/m4n9p43b7q8k1wqbpw264947rm70mj1z-stdenv-bootstrap-tools-armv6l-unknown-linux-musleabihf/on-server/bootstrap-tools.tar.xz;
    sha256 = "1n9wm08fg99wa1q3ngim6n6bg7kxlkzx2v7fqw013rb3d5drjwrq";
  };
}
