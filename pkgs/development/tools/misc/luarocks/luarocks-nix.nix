{ luarocks, fetchFromGitHub }:
luarocks.overrideAttrs(old: {
  pname = "luarocks-nix";
  src = fetchFromGitHub {
    owner = "teto";
    repo = "luarocks";
    rev = "ca52159dcb544161e5bef1e4e366f3da31fa4555";
    sha256 = "13g7vpyirq51qmmnjsqhhiia9wdnq9aw4da0n3r7l1ar95q168sn";
  };
})
