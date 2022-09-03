{ luarocks, fetchFromGitHub, unstableGitUpdater }:
luarocks.overrideAttrs(old: {
  pname = "luarocks-nix";
  version = "unstable-2022-09-04";

  src = fetchFromGitHub {
    owner = "nix-community";
    repo = "luarocks-nix";
    rev = "cfc1439a29ac666fb0fcf440224adf73004655d4";
    sha256 = "sha256-uHkE9ztOZDs2pi7to3kZ0iELRhv/gPQgTK+qyYpFZ/Y=";
  };

  patches = [];

  passthru = {
    updateScript = unstableGitUpdater {
      branch = "use-fetchzip";
    };
  };

  meta =  {
    mainProgram = "luarocks";
  };
})
