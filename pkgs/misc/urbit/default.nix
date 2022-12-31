{
  pkgs,
  callPackage,
  fetchFromGitHub,
  curlMinimal,
  openssl,
  zlib,
  lib,
  stdenv,
}: let
  fetchGitHubLFS = callPackage ./fetch-github-lfs.nix {};
  urbit-src = fetchFromGitHub {
    owner = "urbit";
    repo = "urbit";
    rev = "urbit-v1.15";
    hash = "sha256-YHl4aPJglUIQ6mrLWSUU7gNJn9DjeCwNBCCUkDfX2iw=";
  };
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
  ivory = callPackage ./pill/ivory.nix {
    arvo = false;
    solid = false;
    urbit = false;
    bootFakeShip = false;
    inherit urbit-src;
    inherit fetchGitHubLFS;
  };
  openssl-static-osx = openssl;
  softfloat3 = callPackage ./softfloat3.nix {
    inherit sources;
  };
  optionalList = xs: if xs == null then [ ] else xs;
  curlUrbit = curlMinimal.override {
    http2Support = false;
    scpSupport = false;
    gssSupport = false;
    ldapSupport = false;
    brotliSupport = false;
  };
  h2o = pkgs.h2o.overrideAttrs (_attrs: {
    version = sources.h2o.rev;
    src = sources.h2o;
    outputs = [ "out" "dev" "lib" ];
    meta.platforms = lib.platforms.linux ++ lib.platforms.darwin;
  });
  libsigsegv = pkgs.libsigsegv.overrideAttrs (attrs: {
    patches = optionalList attrs.patches ++ [
      ./libsigsegv/disable-stackvma_fault-linux-arm.patch
      ./libsigsegv/disable-stackvma_fault-linux-i386.patch
    ];
  });
  lmdb = pkgs.lmdb.overrideAttrs (attrs: {
    patches =
      optionalList attrs.patches ++ lib.optional stdenv.isDarwin [
        ./pkgs/lmdb/darwin-fsync.patch
      ];
  });
  zlib-static-osx = zlib;
  urbit = callPackage ./urbit.nix {
    inherit urbit-src libsigsegv curlUrbit zlib-static-osx h2o lmdb;
    inherit ent openssl-static-osx ca-bundle ivory murmur3 softfloat3 urcrypt;
  };
  urcrypt = callPackage ./urcrypt.nix {
    inherit urbit-src;
    inherit openssl-static-osx libaes_siv;
  }; #TODO enableStatic
in urbit
