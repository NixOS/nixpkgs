{ luarocks, fetchFromGitHub }:
luarocks.overrideAttrs(old: {
  pname = "luarocks-nix";
  version = "2021-01-22";
  src = fetchFromGitHub {
    owner = "nix-community";
    repo = "luarocks-nix";
    rev = "test-speedup";
    sha256 = "sha256-WfzLSpIp0V7Ib4sjYvoJHF+/vHaieccvfVAr5W47QsQ=";
  };
  patches = [];

  meta.mainProgram = "luarocks";
})
