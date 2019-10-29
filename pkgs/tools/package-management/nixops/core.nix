{ fetchurl, callPackage, nixopsPlugins }: rec {
  nixopsWithPlugins = { plugins }:
    callPackage ./wrapper.nix (rec {
      version = "1.8pre2870_2434bf2";
      src = fetchurl {
        url = "https://hydra.nixos.org/build/104709722/download/2/nixops-${version}.tar.bz2";
        sha256 = "sha256:1bz561m7clhrick4wnff3y92iw222bd1cn4fz6ln1a2jhvjmrxrv";
      };
      inherit plugins;
    });

  nixopsCore =
    nixopsWithPlugins { plugins = with nixopsPlugins; [ nixops-aws ]; };
}
