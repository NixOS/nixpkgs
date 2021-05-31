{
  busybox = import <nix/fetchurl.nix> {
    url = "http://---/busybox";
    sha256 = "26016bae6b331531c7cef5a4feef7206654e9f033257f5edc4c843d0d5972a3d";
    executable = true;
  };

  bootstrapTools = import <nix/fetchurl.nix> {
    url = "http://---/bootstrap-tools.tar.xz";
    sha256 = "16e888484403f88969f509adb39a8506d74d0ecec8a01db643d8492cd4e80600";
  };
}
