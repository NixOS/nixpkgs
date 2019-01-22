{ luarocks, fetchFromGitHub }:
luarocks.overrideAttrs(old: {
  src = fetchFromGitHub {
    owner = "teto";
    repo = "luarocks";
    rev = "d669e8e118e6ca8bff05f32dbc9e5589e6ac45d2";
    sha256 = "1lay3905a5sx2a4y68lbys0913qs210hcj9kn2lbqinw86c1vyc3";
  };
})
