{ luarocks, fetchFromGitHub, unstableGitUpdater }:

luarocks.overrideAttrs (old: {
  pname = "luarocks-nix";
  version = "unstable-2023-02-26";

  src = fetchFromGitHub {
    owner = "nix-community";
    repo = "luarocks-nix";
    rev = "4cfea3d5d826db4cfbc809ef8bb5f0a9f3a18919";
    sha256 = "sha256-7L8B+/C7Kzt25Ec+OsM2rliYB2/wyZQ3OT63V7AaOxo=";
  };

  patches = [ ];

  passthru = {
    updateScript = unstableGitUpdater { };
  };

  meta = old.meta // {
    mainProgram = "luarocks";
  };
})
