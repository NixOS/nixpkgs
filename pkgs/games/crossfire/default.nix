{ callPackage, ... }:

rec {
  crossfire-client = callPackage ./crossfire-client.nix {
    rev = "v1.75.2";
    version = "1.75.2";
    hash = "sha256-6z7Tf9B7XpMLtAxID5GQOKAI7krFU3WAv6QzKR+CjUM=";
  };

  crossfire-server = callPackage ./crossfire-server.nix {
    rev = "bd28d7c6b74fa006d95dbb07d7b743bcdbd9883e";
    hash = "sha256-7uyWSW6TuyM6enWAuxUIl9Tb9EtTN7a+e0SWI4/6Abs=";
    maps = crossfire-maps; arch = crossfire-arch;
  };

  crossfire-arch = callPackage ./crossfire-arch.nix {
    rev = "0894e2964d8f05eb2686055c195a5046c904ef4f";
    hash = "sha256-AL+zEblk9BgH+aL2vurjtqNg94LwY3ROQCw/gyoSeaY=";
  };

  crossfire-maps = callPackage ./crossfire-maps.nix {
    version = "latest";
    rev = "22111";
    sha256 = "1dwfc84acjvbjgjakkb8z8pdlksbsn90j0z8z8rq37lqx0kx1sap";
  };
}
