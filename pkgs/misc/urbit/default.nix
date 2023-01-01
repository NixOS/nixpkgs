{ lib
, callPackage
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

  fetchGitHubLFS = callPackage ./fetch-github-lfs.nix {};

  sources = callPackage ./sources.nix {};

  ca-bundle = callPackage ./ca-bundle.nix {};

  ent = callPackage ./ent.nix {
    inherit urbit-src;
  };

  libaes_siv = callPackage ./libaes_siv {
    inherit sources;
  };

  murmur3 = callPackage ./murmur3.nix {
    inherit sources;
  };

  ivory-header = callPackage ./ivory-header.nix {
    inherit urbit-src;
    inherit fetchGitHubLFS;
  };

  softfloat3 = callPackage ./softfloat3.nix {
    inherit sources;
  };

  h2o-stable = h2o.overrideAttrs (_attrs: {
    version = sources.h2o.rev;
    src = sources.h2o;
    outputs = [ "out" "dev" "lib" ];
    meta.platforms = lib.platforms.linux ++ lib.platforms.darwin;
  });

  libsigsegv_patched = libsigsegv.overrideAttrs (attrs: {
    patches = (lib.lists.optionals (attrs.patches != null) attrs.patches) ++ [
      ./libsigsegv/disable-stackvma_fault-linux-arm.patch
      ./libsigsegv/disable-stackvma_fault-linux-i386.patch
    ];
  });

  lmdb_patched = lmdb.overrideAttrs (attrs: {
    patches =
      attrs.patches or [] ++ lib.optionals stdenv.isDarwin [
        ./lmdb/darwin-fsync.patch
      ];
  });

  urbit = callPackage ./urbit.nix {
    inherit urbit-src libsigsegv_patched curlMinimal h2o-stable lmdb_patched;
    inherit ent ca-bundle ivory-header murmur3 softfloat3 urcrypt;
  };
  urcrypt = callPackage ./urcrypt.nix {
    inherit urbit-src;
    inherit libaes_siv;
  };
in urbit
