{ luarocks, fetchFromGitHub }:
luarocks.overrideAttrs(old: {
  pname = "luarocks-nix";
  src = fetchFromGitHub {
    owner = "teto";
    repo = "luarocks";
    rev = "38ed82ba3e5682d7d55ef9a870dfb464ca180df9";
    sha256 = "0vlzywiv3sxkpjg1fzzxicmfr6kh04fxw5q9n8vsd2075xjxg6bs";
  };
  patches = [
    ./darwin-3.0.x.patch
  ];
})
