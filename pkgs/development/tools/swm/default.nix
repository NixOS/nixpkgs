{ callPackage }:

let
  version = "0.4.0-alpha1";
  sha256 = "17s6ccwg4240b6ykam27pz4kisyfm977rh1zzzx6ykarqi0x2fkf";

  swm-src = builtins.fetchTarball {
    url = "https://github.com/kalbasit/swm/archive/v${version}.tar.gz";
    inherit sha256;
  };
in
  callPackage swm-src { inherit version; }
