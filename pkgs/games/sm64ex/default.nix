{ lib
, stdenv
, fetchFromGitHub
, callPackage
, autoPatchelfHook
, branch
}:

{
  sm64ex = callPackage ./generic.nix {
    pname = "sm64ex";
    version = "0.pre+date=2021-11-30";

    src = fetchFromGitHub {
      owner = "sm64pc";
      repo = "sm64ex";
      rev = "db9a6345baa5acb41f9d77c480510442cab26025";
      sha256 = "sha256-q7JWDvNeNrDpcKVtIGqB1k7I0FveYwrfqu7ZZK7T8F8=";
    };

    extraMeta = {
      homepage = "https://github.com/sm64pc/sm64ex";
      description = "Super Mario 64 port based off of decompilation";
    };
  };

  sm64ex-coop = callPackage ./generic.nix {
    pname = "sm64ex-coop";
    version = "0.pre+date=2022-05-14";

    src = fetchFromGitHub {
      owner = "djoslin0";
      repo = "sm64ex-coop";
      rev = "8200b175607fe2939f067d496627c202a15fe24c";
      sha256 = "sha256-c1ZmMBtvYYcaJ/WxkZBVvNGVCeSXfm8NKe/BiAIJtks=";
    };

    extraNativeBuildInputs = [
      autoPatchelfHook
    ];

    postInstall = let
      sharedLib = stdenv.hostPlatform.extensions.sharedLibrary;
    in ''
      mkdir -p $out/lib
      cp $src/lib/bass/libbass{,_fx}${sharedLib} $out/lib
      cp $src/lib/discordsdk/libdiscord_game_sdk${sharedLib} $out/lib
    '';

    extraMeta = {
      homepage = "https://github.com/djoslin0/sm64ex-coop";
      description = "Super Mario 64 online co-op mod, forked from sm64ex";
    };
  };
}.${branch}
