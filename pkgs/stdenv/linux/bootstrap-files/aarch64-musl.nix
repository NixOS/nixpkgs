{
  busybox = import <nix/fetchurl.nix> {
    url = https://wdtz.org/files/88snbnw04cldx4c3k9qrd0y2vifld2b2-stdenv-bootstrap-tools-aarch64-unknown-linux-musl/on-server/busybox;
    sha256 = "01s6bwq84wyrjh3rdsgxni9gkzp7ss8rghg0cmp8zd87l79y8y4g";
    executable = true;
  };
  bootstrapTools = import <nix/fetchurl.nix> {
    url = https://wdtz.org/files/88snbnw04cldx4c3k9qrd0y2vifld2b2-stdenv-bootstrap-tools-aarch64-unknown-linux-musl/on-server/bootstrap-tools.tar.xz;
    sha256 = "0n97q17h9i9hyc8c5qklfn6vii1vr87kj4k9acdc52jayv6c3kas";
  };
}
