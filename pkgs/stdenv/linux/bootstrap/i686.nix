{
  busybox = import <nix/fetchurl.nix> {
    url = "https://www.dropbox.com/s/y0dmuojwabpce49/busybox?dl=1";
    sha256 = "0qpl446hnzmdfk92hnfxwl12dxdihrdpmn9qmcmiwc4009f5saq2";
    executable = true;
  };

  bootstrapTools = import <nix/fetchurl.nix> {
    url = "https://www.dropbox.com/s/f7h7w1jh5ty1qmw/bootstrap-tools.tar.xz?dl=1";
    sha256 = "21048fc553a1c3eaddfc37e011b69019ce684bdfe6d2fc9ae771757be932ef0c";
  };
}
