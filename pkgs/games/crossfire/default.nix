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
    rev = "152b17b1d8976856df441c6f87049dee91edbd4a";
    hash = "sha256-0rogLKEEOU1NtC8Np3BjlrdDobLjNGqgVZVQFC7hH30=";
  };

  crossfire-jxclient = callPackage ./crossfire-jxclient.nix {
    version = "2023-06-23";
    rev = "fddc21e368b2f998d968169dc72d4b7ea747f8b0";
    hash = "sha256-7mbns61v2UPMlmZc4kd081dlk+b3yDUpgHqS/NEZ2wc=";
  };

  crossfire-editor = callPackage ./crossfire-editor.nix {
    version = "2023-10-13";
    rev = "6928c5eb7c894d7e97a20af5495d3fb39d66a516";
    hash = "sha256-lPKaH1VmImVP1fgm5UMZUpbM8E5O1sxCZWMzfQ3izco=";
  };
}
