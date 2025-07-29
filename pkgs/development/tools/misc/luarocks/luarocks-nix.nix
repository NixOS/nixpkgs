{
  luarocks_bootstrap,
  fetchFromGitHub,
  unstableGitUpdater,
  nurl,
  file,
}:

luarocks_bootstrap.overrideAttrs (old: {
  pname = "luarocks-nix";
  version = "0-unstable-2024-05-31";

  src = fetchFromGitHub {
    owner = "nix-community";
    repo = "luarocks-nix";
    rev = "9d0440da358eac11afdbef392e2cf3272a8c7101";
    hash = "sha256-9SC+YQ06u35LN3mPohG7Lz0eLXPsMGKG3mhS+0zSO7Y=";
  };

  propagatedNativeBuildInputs = old.propagatedNativeBuildInputs ++ [
    file
    nurl
  ];

  patches = [ ];

  doInstallCheck = false;

  passthru = {
    updateScript = unstableGitUpdater {
      # tags incompletely inherited from regular luarocks
      hardcodeZeroVersion = true;
    };
  };

  # old.meta // { /* ... */ } doesn't update meta.position, which breaks the updateScript
  meta = {
    inherit (old.meta)
      description
      license
      maintainers
      platforms
      ;
    mainProgram = "luarocks";
  };
})
