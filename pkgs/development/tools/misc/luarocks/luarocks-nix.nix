{ luarocks, fetchFromGitHub, unstableGitUpdater }:

luarocks.overrideAttrs (old: {
  pname = "luarocks-nix";
  version = "unstable-2022-10-12";

  src = fetchFromGitHub {
    owner = "nix-community";
    repo = "luarocks-nix";
    rev = "7b3cc90ebf07813ed511f530cc50d602e9502001";
    sha256 = "sha256-zN+8BzUkKUQU/6BWg1kcsL3XV9qehnwm1L4vRKOejPs=";
  };

  patches = [ ];

  passthru = {
    updateScript = unstableGitUpdater { };
  };

  meta = old.meta // {
    mainProgram = "luarocks";
  };
})
