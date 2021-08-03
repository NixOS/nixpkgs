{ luarocks, fetchFromGitHub }:
luarocks.overrideAttrs(old: {
  pname = "luarocks-nix";
  version = "2021-01-22";
  src = fetchFromGitHub {
    owner = "nix-community";
    repo = "luarocks-nix";
    rev = "nix_v3.5.0-1";
    sha256 = "sha256-jcgshxAuuc8QizpYL/2K3PKYWiKsnF/8BJAUaryvEvQ=";
  };
})
