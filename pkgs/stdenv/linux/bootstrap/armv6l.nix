{
  busybox = import <nix/fetchurl.nix> {
    url = "https://www.dropbox.com/s/juwm6smucb3ovbf/busybox?dl=1";
    sha256 = "1s527y1d01ch7byrhr91yfqyz9884q2gmck1f02la787lbk98qlv";
    executable = true;
  };

  bootstrapTools = import <nix/fetchurl.nix> {
    url = "https://www.dropbox.com/s/k3597ob1vss73en/bootstrap-tools.tar.xz?dl=1";
    sha256 = "5fc435357b9059aa2cea01d6fbc383640da6232c41bbdd432885a4b39cab18d1";
  };
}
