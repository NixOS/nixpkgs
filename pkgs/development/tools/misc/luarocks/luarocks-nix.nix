{
  luarocks_bootstrap,
  fetchFromGitHub,
  unstableGitUpdater,
  nurl,
  file,
}:

luarocks_bootstrap.overrideAttrs (old: {
  pname = "luarocks-nix";
  version = "0-unstable-2026-10-18";

  src = fetchFromGitHub {
    owner = "nix-community";
    repo = "luarocks-nix";
    rev = "a3cb5421f9a107c0d24e0d62becef4c3494ad8e0";
    hash = "sha256-1Nyzy5Z7WmIiaxaaUWWSnPPdvS4ghXU5wULguiOSlcs=";
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
    homepage = "https://github.com/nix-community/luarocks-nix";
    mainProgram = "luarocks";
  };
})
