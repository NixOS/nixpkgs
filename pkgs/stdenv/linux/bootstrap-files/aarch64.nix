# FIXME(ma27): before merging this to master we *have* to replace those files
# as they're built for testing purposes with the aarch64 community builder.
{
  busybox = import <nix/fetchurl.nix> {
    url = "https://aarch64.mbosch.me/busybox";
    sha256 = "10z8aigcj0lyfwbc4wzl7s0ng9g37sx1vsqh9sijw3hi0gfhhn4v";
    executable = true;
  };
  bootstrapTools = import <nix/fetchurl.nix> {
    url = "https://aarch64.mbosch.me/bootstrap-tools.tar.xz";
    sha256 = "0n4k0l7j2yqjzicj1gyk8gdpbszqn6yj6mlx6m2pzfcm2hmbzwfk";
  };
}
