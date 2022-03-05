{ luarocks, fetchFromGitHub }:
luarocks.overrideAttrs(old: {
  pname = "luarocks-nix";
  version = "2021-01-22";
  src = fetchFromGitHub {
    owner = "nix-community";
    repo = "luarocks-nix";
    rev = "standalone";
    sha256 = "sha256-53Zi+GTayO9EQTCIVrzPeRRHeIkHLqy0mHyBDzbcQQk=";
  };
  patches = [];

  meta.mainProgram = "luarocks";
})
