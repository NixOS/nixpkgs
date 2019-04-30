{ luarocks, fetchFromGitHub }:
luarocks.overrideAttrs(old: {
  pname = "luarocks-nix";
  src = fetchFromGitHub {
    owner = "teto";
    repo = "luarocks";
    rev = "8fb03a9bc8f4fa079d26c0f02804139bb2578848";
    sha256 = "09iwjvs9sbk6vwhrh7sijmfpji6wvg5bbdraw7l5lpnr9jj5wy91";
  };
})
