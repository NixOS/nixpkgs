{ lib
, boehmgc
, callPackage
, fetchFromGitHub
, fetchurl
, Security

, storeDir ? "/nix/store"
, stateDir ? "/nix/var"
, confDir ? "/etc"
}:
let
  boehmgc_nix_2_3 = boehmgc.override { enableLargeConfig = true; };

  boehmgc_nix = boehmgc_nix_2_3.overrideAttrs (drv: {
    # Part of the GC solution in https://github.com/NixOS/nix/pull/4944
    patches = (drv.patches or [ ]) ++ [ ./patches/boehmgc-coroutine-sp-fallback.patch ];
  });

  buildNix =
    { version
    , suffix ? ""
    , src ? null
    , sha256  ? null
    , boehmgc ? boehmgc_nix
    , patches ? [ ]
    }:
      assert (src == null) -> (sha256 != null);
      assert (sha256 == null) -> (src != null);
    callPackage ./common.nix {
      inherit version suffix;

      src =
        if src != null
        then src
        else fetchFromGitHub {
          owner = "NixOS";
          repo = "nix";
          rev = version;
          inherit sha256;
        };

      inherit boehmgc patches Security;
      inherit storeDir stateDir confDir;
    };
in rec {
  nix = nix_2_5;

  nix_2_3 = buildNix rec {
    version = "2.3.16";
    src = fetchurl {
      url = "https://nixos.org/releases/nix/nix-${version}/nix-${version}.tar.xz";
      sha256 = "sha256-fuaBtp8FtSVJLSAsO+3Nne4ZYLuBj2JpD2xEk7fCqrw=";
    };
    boehmgc = boehmgc_nix_2_3;
  };

  nix_2_4 = buildNix {
    version = "2.4";
    sha256 = "sha256-op48CCDgLHK0qV1Batz4Ln5FqBiRjlE6qHTiZgt3b6k=";
    # https://github.com/NixOS/nix/pull/5537
    patches = [ ./patches/install-nlohmann_json-headers.patch ];
  };

  nix_2_5 = buildNix {
    version = "2.5.1";
    sha256 = "sha256-GOsiqy9EaTwDn2PLZ4eFj1VkXcBUbqrqHehRE9GuGdU=";
    # https://github.com/NixOS/nix/pull/5536
    patches = [ ./patches/install-nlohmann_json-headers.patch ];
  };

  nix_2_6 = buildNix {
    version = "2.6.0";
    sha256 = "sha256-xEPeMcNJVOeZtoN+d+aRwolpW8mFSEQx76HTRdlhPhg=";
  };

  nixUnstable = lib.lowPrio (buildNix rec {
    version = "2.7";
    suffix = "pre20220124_${lib.substring 0 7 src.rev}";
    src = fetchFromGitHub {
      owner = "NixOS";
      repo = "nix";
      rev = "0a70b37b5694c769fb855c1afe7642407d1db64f";
      sha256 = "sha256-aOM9MPNlnWNMobx4CuD4JIXH2poRlG8AKkuxY7FysWg=";
    };
  });
}
