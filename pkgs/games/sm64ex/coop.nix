{ callPackage
, fetchFromGitHub
, autoPatchelfHook
, zlib
, stdenvNoCC
}:

callPackage ./generic.nix {
  pname = "sm64ex-coop";
  version = "unstable-2023-06-25";

  src = fetchFromGitHub {
    owner = "djoslin0";
    repo = "sm64ex-coop";
    rev = "4f62baebcce44b16a2bd7b0ee903577767e31154";
    sha256 = "sha256-WlZ8es0JnywUBEWnxlZfcL6GSF4bwqc/rcG8BM15+Lo=";
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
      cp -r $src/lang $out/share/sm64ex/lang
    '';

  extraMeta = {
    homepage = "https://github.com/djoslin0/sm64ex-coop";
    description = "Super Mario 64 online co-op mod, forked from sm64ex";
  };
}
