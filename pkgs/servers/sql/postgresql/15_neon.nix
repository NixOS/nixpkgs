let
  neonRev = "2aaab3bb4a13557aae05bb2ae0ef0a132d0c4f85";
  base = import ./generic.nix {
    version = "15.13";
    rev = neonRev;
    hash = "";
  };
in
{ self, ... }@args:
(base (args // { jitSupport = false; })).overrideAttrs (prev: {
  pname = "postgresql-neon";
  src = self.fetchFromGitHub {
    owner = "neondatabase";
    repo = "postgres";
    rev = neonRev;
    hash = "sha256-E+a7OsB7doDqGs9dwWhmD+fO1dgYB1nDvB33EDGl7gc=";
  };
  doInstallCheck = false;
})
