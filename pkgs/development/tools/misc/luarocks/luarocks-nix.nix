{ luarocks, fetchFromGitHub }:
luarocks.overrideAttrs(old: {
  pname = "luarocks-nix";
  src = fetchFromGitHub {
    owner = "teto";
    repo = "luarocks";
    rev = "595456f1246d66e5bdce0de838d0d6188274991c";
    sha256 = "14nn0n5a0m516lnbwljy85h7y98zwnfbcyz7hgsm6fn4p8316yz2";
  };
})
