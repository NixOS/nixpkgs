{
  busybox = import <nix/fetchurl.nix> {
    url = "https://www.dropbox.com/s/us0xzgbfmvbcban/busybox?dl=1";
    sha256 = "05h6yrqmw7pvjl15a1f4v0x3k90157cvbkc2h2pjry4mzfbj3ig4";
    executable = true;
  };

  bootstrapTools = import <nix/fetchurl.nix> {
    url = "https://www.dropbox.com/s/lhjyxloe8wzt37w/bootstrap-tools.tar.xz?dl=1";
    sha256 = "7a33b7de185f6aef6325d1d59321880486578ea27bbaccdb659aa102f775ecb8";
  };
}
