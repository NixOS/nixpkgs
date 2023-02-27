{ callPackage
, fetchFromGitHub
, autoPatchelfHook
, zlib
, stdenvNoCC
}:

callPackage ./generic.nix {
  pname = "sm64ex-coop";
  version = "0.pre+date=2022-08-05";

  src = fetchFromGitHub {
    owner = "djoslin0";
    repo = "sm64ex-coop";
    rev = "68634493de4cdd9db263e0f4f0b9b6772a60d30a";
    sha256 = "sha256-3Ve93WGyBd8SAA0TBrpIrhj+ernjn1q7qXSi9mp36cQ=";
  };

  extraNativeBuildInputs = [
    autoPatchelfHook
  ];

  extraBuildInputs = [
    zlib
  ];

  postInstall =
    let
      sharedLib = stdenvNoCC.hostPlatform.extensions.sharedLibrary;
    in
    ''
      mkdir -p $out/lib
      cp $src/lib/bass/libbass{,_fx}${sharedLib} $out/lib
      cp $src/lib/discordsdk/libdiscord_game_sdk${sharedLib} $out/lib
    '';

  extraMeta = {
    homepage = "https://github.com/djoslin0/sm64ex-coop";
    description = "Super Mario 64 online co-op mod, forked from sm64ex";
  };
}
