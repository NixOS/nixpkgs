import ./generic.nix {
  version = "2.17.9";
  hash = "sha256-4bP6RyZ2YmhT8i1j+VnlrQYeG/V+G71ETQ7Yj5R++LE=";
  updateScriptArgs = "--lts=true --regex '2\.17.*'";
}
