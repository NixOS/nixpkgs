{
  # Note: do not use Hydra as a source URL. Ask a member of the
  # infrastructure team to mirror the job.
  busybox = import <nix/fetchurl.nix> {
    # from job: https://hydra.nixos.org/job/nixpkgs/cross-trunk/bootstrapTools.powerpc64le.dist
    # from build: https://hydra.nixos.org/build/155848348
    # TODO(pmc): ask infra to mirror this
    # url = "http://tarballs.nixos.org/stdenv-linux/powerpc64le/0eb0ddc4dbe3cd5415c6b6e657538eb809fc3778/busybox";
    url = "https://nix-cache.piperswe.me/bootstrap/wnjkv15kl6pn4jw4dqwqy7i364w6qqvr-stdenv-bootstrap-tools-sparc64-unknown-linux-gnu/on-server/busybox";
    sha256 = "sha256-T9ak4aH9LJBtFlT1fJWaw7xaYmMZOBMstrXCwq5MK+M=";
    executable = true;
  };
  bootstrapTools = import <nix/fetchurl.nix> {
    # from job: https://hydra.nixos.org/job/nixpkgs/cross-trunk/bootstrapTools.armv7l.dist/latest
    # from build: https://hydra.nixos.org/build/114203060
    # TODO(pmc): ask infra to mirror this
    # url = "http://tarballs.nixos.org/stdenv-linux/powerpc64le/0eb0ddc4dbe3cd5415c6b6e657538eb809fc3778/bootstrap-tools.tar.xz";
    url = "https://nix-cache.piperswe.me/bootstrap/wnjkv15kl6pn4jw4dqwqy7i364w6qqvr-stdenv-bootstrap-tools-sparc64-unknown-linux-gnu/on-server/bootstrap-tools.tar.xz";
    sha256 = "sha256-2z5mNuGjS8lJVA/jEyu9lq/byIYUSAmCOM44p4YWnrg=";
  };
}
