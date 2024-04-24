{
  busybox = import <nix/fetchurl.nix> {
    url = "http://tarballs.nixos.org/stdenv-linux/aarch64/21ec906463ea8f11abf3f9091ddd4c3276516e58/busybox";
    executable = true;
    hash = "sha256-0MuIeQlBUaeisqoFSu8y+8oB6K4ZG5Lhq8RcS9JqkFQ=";
  };
  bootstrapTools = import <nix/fetchurl.nix> {
    url = "http://tarballs.nixos.org/stdenv-linux/aarch64/21ec906463ea8f11abf3f9091ddd4c3276516e58/bootstrap-tools.tar.xz";
    hash = "sha256-aJvtsWeuQHbb14BGZ2EiOKzjQn46h3x3duuPEawG0eE=";
  };
}
