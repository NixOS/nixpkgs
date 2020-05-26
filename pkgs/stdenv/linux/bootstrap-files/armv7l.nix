{
  # Note: do not use Hydra as a source URL. Ask a member of the
  # infrastructure team to mirror the job.
  busybox = import <nix/fetchurl.nix> {
    # from job: https://hydra.nixos.org/job/nixpkgs/cross-trunk/bootstrapTools.armv7l.dist/latest
    # from build: https://hydra.nixos.org/build/114203060
    url = "http://tarballs.nixos.org/stdenv-linux/armv7l/0eb0ddc4dbe3cd5415c6b6e657538eb809fc3778/busybox";
    # note: the following hash is different than the above hash, due to executable = true
    sha256 = "18qc6w2yykh7nvhjklsqb2zb3fjh4p9r22nvmgj32jr1mjflcsjn";
    executable = true;
  };
  bootstrapTools = import <nix/fetchurl.nix> {
    # from job: https://hydra.nixos.org/job/nixpkgs/cross-trunk/bootstrapTools.armv7l.dist/latest
    # from build: https://hydra.nixos.org/build/114203060
    url = "http://tarballs.nixos.org/stdenv-linux/armv7l/0eb0ddc4dbe3cd5415c6b6e657538eb809fc3778/bootstrap-tools.tar.xz";
    sha256 = "cf2968e8085cd3e6b3e9359624060ad24d253800ede48c5338179f6e0082c443";
  };
}
