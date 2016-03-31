{
  busybox = import <nix/fetchurl.nix> {
    url = https://abbradar.net/me/pub/shlib-no-undefined/i686/busybox;
    sha256 = "18fbjl8pdwwzz9ln9i34jdvdc172sbi0mnggakvf8mxfqzk1nk7g";
    executable = true;
  };

  bootstrapTools = import <nix/fetchurl.nix> {
    url = https://abbradar.net/me/pub/shlib-no-undefined/i686/bootstrap-tools.tar.xz;
    sha256 = "1w15ap7c8ld55774kj8sz1rmy1wqr0carr73cfqiny97g6kj1ar8";
  };
}
