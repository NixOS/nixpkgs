{
  busybox = import <nix/fetchurl.nix> {
    url = https://hydra.nixos.org/build/112609103/download/2/busybox;
    sha256 = "566a469dac214b31e4abdb0a91d32550bab1be5858d329e1b6074eef05370ca3";
    executable = true;
  };

  bootstrapTools = import <nix/fetchurl.nix> {
    url = https://hydra.nixos.org/build/112609103/download/1/bootstrap-tools.tar.xz;
    sha256 = "79fa2d7722aeb856c7c9b62a3fd64b6d261fd6f6bcbac486f0a2a7d823210550";
  };
}
