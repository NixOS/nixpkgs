{ luarocks, fetchFromGitHub, unstableGitUpdater }:

luarocks.overrideAttrs (old: {
  pname = "luarocks-nix";
  version = "0-unstable-2023-10-19";

  src = fetchFromGitHub {
    owner = "nix-community";
    repo = "luarocks-nix";
    rev = "4240b25b95d7165cde66fc2acaf5a0f9ad40fd0c";
    sha256 = "sha256-dqFFYehBgK0RqH0/1GtZXq7XLGCcc3Kfadq8ICYNCWk=";
  };

  patches = [ ];

  passthru = {
    updateScript = unstableGitUpdater {
      # tags incompletely inherited from regular luarocks
      hardcodeZeroVersion = true;
    };
  };

  # old.meta // { /* ... */ } doesn't update meta.position, which breaks the updateScript
  meta = {
    inherit (old.meta) description license maintainers platforms;
    mainProgram = "luarocks";
  };
})
