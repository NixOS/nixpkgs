{
  busybox = import <nix/fetchurl.nix> {
    url = https://dl.dropboxusercontent.com/s/4705ffxjrxxqnh2/busybox?dl=0;
    sha256 = "032maafy4akcdgccpxdxrza29pkcpm81g8kh1hv8bj2rvssly3z2";
    executable = true;
  };

  bootstrapTools = import <nix/fetchurl.nix> {
    url = https://dl.dropboxusercontent.com/s/pen8ieymeqqdvqn/bootstrap-tools.tar.xz?dl=0;
    sha256 = "0kjpjwi6qw82ca02ppsih3bnhc3y150q23k9d56xzscs0xf5d0dv";
  };
}
