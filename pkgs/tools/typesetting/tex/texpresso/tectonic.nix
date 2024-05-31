{ tectonic-unwrapped, fetchFromGitHub }:
tectonic-unwrapped.override (old: {
  rustPlatform = old.rustPlatform // {
    buildRustPackage = args: old.rustPlatform.buildRustPackage (args // {
      pname = "texpresso-tonic";
      src = fetchFromGitHub {
        owner = "let-def";
        repo = "tectonic";
        rev = "bc522fabfdd17099deac2e12662b2a0810ceb104";
        hash = "sha256-0esXnUML6C9DYrpmBBB+ACypLvnLsYE9fuNiiCFfYzw=";
        fetchSubmodules = true;
      };
      cargoHash = "sha256-62sxvPIiY3len1wsl7QelK3u4ekftIjcTqoIGZMYb5A=";
      # binary has a different name, bundled tests won't work
      doCheck = false;
      meta.mainProgram = "texpresso-tonic";
    });
  };
})
