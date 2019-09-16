{ luarocks, fetchFromGitHub }:
luarocks.overrideAttrs(old: {
  pname = "luarocks-nix";
  version = "2019-09-07";
  src = fetchFromGitHub {
    owner = "nix-community";
    repo = "luarocks";
    rev = "fa7c367bcdad36768db5f19fd4fcdd9681a14429";
    sha256 = "0kziwfw5gqq5xsckl7qf9wasaiy8rp42h5qrcnjx07qp47a9ldx7";
  };
  patches = [
    ./darwin-3.1.3.patch
  ];
})
