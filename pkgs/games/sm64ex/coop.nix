{
  callPackage,
  fetchFromGitHub,
  autoPatchelfHook,
  zlib,
  stdenvNoCC,
}:

callPackage ./generic.nix {
  pname = "sm64ex-coop";
  version = "unstable-2023-02-22";

  src = fetchFromGitHub {
    owner = "djoslin0";
    repo = "sm64ex-coop";
    rev = "8746a503086793c87860daadfaeaaf0a31b2d6cf";
    sha256 = "sha256-iwJsq0FN9npxveIoMiB7zL5j1V72IExtEpzGj6lwLXQ=";
  };

  extraNativeBuildInputs = [ autoPatchelfHook ];

  extraBuildInputs = [ zlib ];

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
