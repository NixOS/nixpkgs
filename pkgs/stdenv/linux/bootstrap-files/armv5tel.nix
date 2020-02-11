{
  busybox = import <nix/fetchurl.nix> {
    url = https://hydra.nixos.org/build/112609163/download/2/busybox;
    sha256 = "0dc5471dc6a5f69ad98eb7445f51a61e88aa5792d7a677025bf012bdb513b763";
    executable = true;
  };

  bootstrapTools = import <nix/fetchurl.nix> {
    url = https://hydra.nixos.org/build/112609163/download/1/bootstrap-tools.tar.xz;
    sha256 = "ca0564eca4eb944649ce10ec70859640427bf2241243af62812b163176487e02";
  };
}
