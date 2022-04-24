{ luarocks, fetchFromGitHub }:
luarocks.overrideAttrs(old: {
  pname = "luarocks-nix";
  version = "2021-01-22";
  src = fetchFromGitHub {
    owner = "nix-community";
    repo = "luarocks-nix";
    rev = "6aa1d59e88eaef72d699477c3e7aa98b274ca405";
    sha256 = "sha256-nQLl01RFYZYhpShz0gHxnhwFPvTgALpAbjFPIuTD2D0=";
  };
  patches = [];

  meta.mainProgram = "luarocks";
})
