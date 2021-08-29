{ luarocks, fetchFromGitHub }:
luarocks.overrideAttrs(old: {
  pname = "luarocks-nix";
  version = "2021-01-22";
  src = fetchFromGitHub {
    owner = "nix-community";
    repo = "luarocks-nix";
    rev = "v3.5.0_nix";
    sha256 = "sha256-Ea3PVkCaUPO/mvVZtHtD1G9T/Yom28M9oN6duY4ovHk=";
  };
})
