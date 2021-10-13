{
  # Note: do not use Hydra as a source URL. Ask a member of the
  # infrastructure team to mirror the job.
  busybox = import <nix/fetchurl.nix> {
    # from job: https://hydra.nixos.org/job/nixpkgs/cross-trunk/bootstrapTools.powerpc64le.dist
    # from build: https://hydra.nixos.org/build/155848348
    # TODO(pmc): ask infra to mirror this
    # url = "http://tarballs.nixos.org/stdenv-linux/powerpc64le/0eb0ddc4dbe3cd5415c6b6e657538eb809fc3778/busybox";
    url = "https://nix-cache.piperswe.me/bootstrap/7znrqcmp15b93k3bz0yyczqi73dj713v-stdenv-bootstrap-tools-powerpc64le-unknown-linux-gnu/on-server/busybox";
    sha256 = "sha256-nOJImyOtWg2WuXgu9SLKKHiVtmygAQxDutmec98XD9A=";
    executable = true;
  };
  bootstrapTools = import <nix/fetchurl.nix> {
    # from job: https://hydra.nixos.org/job/nixpkgs/cross-trunk/bootstrapTools.armv7l.dist/latest
    # from build: https://hydra.nixos.org/build/114203060
    # TODO(pmc): ask infra to mirror this
    # url = "http://tarballs.nixos.org/stdenv-linux/powerpc64le/0eb0ddc4dbe3cd5415c6b6e657538eb809fc3778/bootstrap-tools.tar.xz";
    url = "https://nix-cache.piperswe.me/bootstrap/7znrqcmp15b93k3bz0yyczqi73dj713v-stdenv-bootstrap-tools-powerpc64le-unknown-linux-gnu/on-server/bootstrap-tools.tar.xz";
    sha256 = "sha256-QsTMZZF0GUFj+YQ5aF9YxEzyDSIhIYBBFVmpNYoDPdg=";
  };
}
