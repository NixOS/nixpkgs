{
  busybox = import <nix/fetchurl.nix> {
    url = "https://www.dropbox.com/s/554i0atsslnhd2b/busybox?dl=1";
    sha256 = "12rbxw15850q1y9n84a8xmg1r2gi3hma70f6iv42q8m5221v6zaf";
    executable = true;
  };

  bootstrapTools = import <nix/fetchurl.nix> {
    url = "https://www.dropbox.com/s/q947b3agmpv30xt/bootstrap-tools.tar.xz?dl=1";
    sha256 = "5b8ef7fc963ff5b2b6555073bed1e3bde8d0e8a95ba769f9d44d716c8de11dc5";
  };
}
