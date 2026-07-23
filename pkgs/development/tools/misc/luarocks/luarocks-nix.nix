{
  luarocks_bootstrap,
  fetchFromGitHub,
  unstableGitUpdater,
  nurl,
  file,
}:

luarocks_bootstrap.overrideAttrs (old: {
  pname = "luarocks-nix";
  version = "nix_v3.5.0-1-unstable-2026-03-31";

  src = fetchFromGitHub {
    owner = "nix-community";
    repo = "luarocks-nix";
    rev = "3a9f4bff6cdda670f866fb9f755d548a714f680a";
    hash = "sha256-6DLy1scf6K1fWDgrORcd1gtymgxtPwwAMIzMG2Bn1Pw=";
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
