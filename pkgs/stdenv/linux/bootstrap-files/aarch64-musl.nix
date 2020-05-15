{
  busybox = import <nix/fetchurl.nix> {
    url = "https://wdtz.org/files/wjzsj9cmdkc70f78yh072483x8656nci-stdenv-bootstrap-tools-aarch64-unknown-linux-musl/on-server/busybox";
    sha256 = "01s6bwq84wyrjh3rdsgxni9gkzp7ss8rghg0cmp8zd87l79y8y4g";
    executable = true;
  };
  bootstrapTools = import <nix/fetchurl.nix> {
    url = "https://wdtz.org/files/wjzsj9cmdkc70f78yh072483x8656nci-stdenv-bootstrap-tools-aarch64-unknown-linux-musl/on-server/bootstrap-tools.tar.xz";
    sha256 = "0pbqrw9z4ifkijpfpx15l2dzi00rq8c5zg9ghimz5qgr5dx7f7cl";
  };
}
