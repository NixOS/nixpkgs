{ lib
, pkgs
, fetchFromGitHub
, curlMinimal
, openssl
, h2o
, libsigsegv
, lmdb
, zlib
, stdenv
}: let

  urbit-src = fetchFromGitHub {
    owner = "urbit";
    repo = "urbit";
    rev = "urbit-v1.15";
    hash = "sha256-YHl4aPJglUIQ6mrLWSUU7gNJn9DjeCwNBCCUkDfX2iw=";
  };

  callPackage = lib.callPackageWith ( pkgs // urbitPackages);

  urbitPackages = {

    fetchGitHubLFS = callPackage ./fetch-github-lfs.nix {};

    ca-bundle = callPackage ./ca-bundle.nix {};

    ent = callPackage ./ent.nix {
      inherit urbit-src;
    };

    libaes_siv = callPackage ./libaes_siv {};

    murmur3 = callPackage ./murmur3.nix {};

    ivory-header = callPackage ./ivory-header.nix {
      inherit urbit-src;
    };

    softfloat3 = callPackage ./softfloat3.nix {};

    h2o-stable = h2o.overrideAttrs (_attrs: {
      version = "v2.2.6";
      src = fetchFromGitHub {
        owner = "h2o";
        repo = "h2o";
        rev = "v2.2.6";
        sha256 = "0qni676wqvxx0sl0pw9j0ph7zf2krrzqc1zwj73mgpdnsr8rsib7";
      };
      outputs = [ "out" "dev" "lib" ];
      meta.platforms = lib.platforms.unix;
    });

    libsigsegv_patched = libsigsegv.overrideAttrs (oldAttrs: {
      patches = (lib.lists.optionals (oldAttrs.patches != null) oldAttrs.patches) ++ [
        ./libsigsegv/disable-stackvma_fault-linux-arm.patch
        ./libsigsegv/disable-stackvma_fault-linux-i386.patch
      ];
    });

    lmdb_patched = lmdb.overrideAttrs (oldAttrs: {
      patches =
        oldAttrs.patches or [] ++ lib.optionals stdenv.isDarwin [
          ./lmdb/darwin-fsync.patch
        ];
    });

    urbit = callPackage ./urbit.nix {
      inherit urbit-src;
    };

    urcrypt = callPackage ./urcrypt.nix {
      inherit urbit-src;
    };
  };

in urbitPackages.urbit
