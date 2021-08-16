{ luarocks, fetchFromGitHub }:
luarocks.overrideAttrs(old: {
  pname = "luarocks-nix";
  version = "2021-01-22";
  src = /home/teto/luarocks;
  # src = fetchFromGitHub {
  #   owner = "nix-community";
  #   repo = "luarocks-nix";
  #   rev = "test-speedup";
  #   sha256 = "sha256-AN4D69IUfCnIWmM7CXWmXeNcTgRCIOamfjYEL4ti9CQ=";
  # };
  patches = [];
  # src = builtins.fetchGit {
  #   url = "https://github.com/nix-community/luarocks-nix.git";
  #   ref = "test-speedup";
  #   rev = "f9cb2285fda1d73bfa8ae33b6102b286dbe1f098";
  # };

  meta.mainProgram = "luarocks";
})
