{
  busybox = import <nix/fetchurl.nix> {
    url = "https://wdtz.org/files/xmz441m69qrlfdw47l2k10zf87fsya6r-stdenv-bootstrap-tools-armv6l-unknown-linux-musleabihf/on-server/busybox";
    sha256 = "01d0hp1xgrriiy9w0sd9vbqzwxnpwiyah80pi4vrpcmbwji36j1i";
    executable = true;
  };
  bootstrapTools = import <nix/fetchurl.nix> {
    url = "https://wdtz.org/files/xmz441m69qrlfdw47l2k10zf87fsya6r-stdenv-bootstrap-tools-armv6l-unknown-linux-musleabihf/on-server/bootstrap-tools.tar.xz";
    sha256 = "1r9mz9w8y5jd7gfwfsrvs20qarzxy7bvrp5dlm41hnx6z617if1h";
  };
}
