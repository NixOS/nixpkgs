{ luarocks, fetchFromGitHub }:
luarocks.overrideAttrs(old: {
  pname = "luarocks-nix";
  version = "2019-09-07";
  src = fetchFromGitHub {
    owner = "nix-community";
    repo = "luarocks-nix";
    rev = "73b8772e56fd39dfffda9e3b13e9eb31e93d5cde";
    sha256 = "00jgshygw439pbaxg7yph3ijia6nid9r1br416wdbyl5wqhlhm1y";
  };
  patches = [
    ./darwin-3.1.3.patch
  ];
})
