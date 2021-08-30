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
  # src = builtins.fetchGit {
  #   url = "https://github.com/nix-community/luarocks-nix.git";
  #   ref = "test-speedup";
  #   rev = "68ebd5356206a625021b9add4ec2f916692a55eb";
  # };

  meta.mainProgram = "luarocks";
})
