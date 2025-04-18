{ callPackage, ... }:

rec {
  crossfire-client = callPackage ./crossfire-client.nix {
    version = "1.75.0";
    rev = "21760";
    sha256 = "0b42sak8hj60nywfswkps777asy9p8r9wsn7pmj2nqbd29ng1p9d";
  };

  crossfire-server = callPackage ./crossfire-server.nix {
    version = "latest";
    rev = "5f742b9f9f785e4a59a3a463bee1f31c9bc67098";
    hash = "sha256-e7e3xN7B1cv9+WkZGzOJgrFer50Cs0L/2dYB9RmGCiE=";
    maps = crossfire-maps;
    arch = crossfire-arch;
  };

  crossfire-arch = callPackage ./crossfire-arch.nix {
    version = "latest";
    rev = "876eb50b9199e9aa06175b7a7d85832662be3f78";
    hash = "sha256-jDiAKcjWYvjGiD68LuKlZS4sOR9jW3THp99kAEdE+y0=";
  };

  crossfire-maps = callPackage ./crossfire-maps.nix {
    version = "latest";
    rev = "ec57d473064ed1732adb1897415b56f96fbd9382";
    hash = "sha256-hJOMa8c80T4/NC37NKM270LDHNqWK6NZfKvKnFno9TE=";
  };
}
