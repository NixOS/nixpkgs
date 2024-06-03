{ luarocks
, fetchFromGitHub
, unstableGitUpdater
, nurl
, file
}:

luarocks.overrideAttrs (old: {
  pname = "luarocks-nix";
  version = "0-unstable-2024-04-29";

  src = fetchFromGitHub {
    owner = "nix-community";
    repo = "luarocks-nix";
    rev = "a473a8f479711682f5b97a72362736d96efd463b";
    hash = "sha256-hsjv+jlLsoIDM4gB/0mFeoVu1YZ1I9ELDALLTEnlCF0=";
  };

  propagatedBuildInputs = old.propagatedBuildInputs ++ [
    file
    nurl
  ];

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
