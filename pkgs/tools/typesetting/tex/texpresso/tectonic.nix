{ tectonic-unwrapped, fetchFromGitHub }:
tectonic-unwrapped.override (old: {
  rustPlatform = old.rustPlatform // {
    buildRustPackage = args: old.rustPlatform.buildRustPackage (args // {
      pname = "texpresso-tonic";
      src = fetchFromGitHub {
        owner = "let-def";
        repo = "tectonic";
        rev = "7729f1360a7e1e8b8a9f8a6a23f96b5f7cc023d0";
        hash = "sha256-OyVkA2EuejxpQvA6pOuFaZh8ghZZ3HaV9q5DZ/2sIrY=";
        fetchSubmodules = true;
      };
      cargoHash = "sha256-62sxvPIiY3len1wsl7QelK3u4ekftIjcTqoIGZMYb5A=";
      # binary has a different name, bundled tests won't work
      doCheck = false;
      meta.mainProgram = "texpresso-tonic";
    });
  };
})
