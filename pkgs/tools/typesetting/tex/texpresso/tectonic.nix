{ tectonic-unwrapped, fetchFromGitHub }:
tectonic-unwrapped.override (old: {
  rustPlatform = old.rustPlatform // {
    buildRustPackage = args: old.rustPlatform.buildRustPackage (args // {
      pname = "texpresso-tonic";
      src = fetchFromGitHub {
        owner = "let-def";
        repo = "tectonic";
        rev = "a6d47e45cd610b271a1428898c76722e26653667";
        hash = "sha256-CDky1NdSQoXpTVDQ7sJWjcx3fdsBclO9Eun/70iClcI=";
        fetchSubmodules = true;
      };
      cargoHash = "sha256-M4XYjBK2MN4bOrk2zTSyuixmAjZ0t6IYI/MlYWrmkIk=";
      # binary has a different name, bundled tests won't work
      doCheck = false;
      meta.mainProgram = "texpresso-tonic";
    });
  };
})
