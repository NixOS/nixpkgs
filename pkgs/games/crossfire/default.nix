pkgs:

let
  callPackage = pkgs.callPackage;
in rec {
  crossfire-client = callPackage ./crossfire-client.nix {
    version = "1.73.0"; rev = 20680;
    sha256 = "192y9nmskrx907h16p8rl4cvksnh5m0q8kz9cxw376sq7gam7g0y";
  };

  crossfire-server-stable = callPackage ./crossfire-server.nix {
    version = "1.71.0"; rev = 19312;
    sha256 = "0ymr31n9w88yd7nb3lfgiwjppvsz77ajqdg47l2b9d2fl342sm9i";
    maps = crossfire-maps-stable; arch = crossfire-arch-stable;
  };
  crossfire-arch-stable = callPackage ./crossfire-arch.nix {
    version = "1.71.0"; rev = 19308;
    sha256 = "1jl4a6yy0hvf416nyhga7mq4wns6c6w91aqd52p2mh1zny428c3n";
  };
  crossfire-maps-stable = callPackage ./crossfire-maps.nix {
    version = "1.71.0"; rev = 19309;
    sha256 = "1rplbrac5dyw742zijfdq63s7ij7d5277fscas0a5p50768ymyrp";
  };

  crossfire-server-latest = callPackage ./crossfire-server.nix {
    version = "latest"; rev = 20926;
    sha256 = "00z8c9bk6gkyggl47klw1gadlzid5cimallz184cppsxbngqmsx6";
    maps = crossfire-maps-latest; arch = crossfire-arch-latest;
  };
  crossfire-arch-latest = callPackage ./crossfire-arch.nix {
    version = "latest"; rev = 20926;
    sha256 = "12yc9cn9yxazaagh2csi9djph6mfcggxvaxkra6fd10x2nbczw4g";
  };
  crossfire-maps-latest = callPackage ./crossfire-maps.nix {
    version = "latest"; rev = 20926;
    sha256 = "0zx0bml3kxq16k4pjcym65kawzlzc2883b5c4dpj34l3n0glhx3p";
  };
}
