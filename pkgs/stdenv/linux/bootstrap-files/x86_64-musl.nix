# Use busybox for i686-linux since it works on x86_64-linux as well.
(import ./i686.nix) //

{
  bootstrapTools = import <nix/fetchurl.nix> {
    # XXX: Find a permanent location for this
    url = https://wdtz.org/files/5zfs7s729n4lrlxmhlnc6qmfrlhahy9s-stdenv-bootstrap-tools-x86_64-unknown-linux-musl/on-server/bootstrap-tools.tar.xz;
    sha256 = "0lwi08c2v7ip2z9li597ixywix976561hr358z2fbd6sqi943axl";
  };
}
