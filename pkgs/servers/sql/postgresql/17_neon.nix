let
  neonRev = "1e01fcea2a6b38180021aa83e0051d95286d9096";
  base = import ./generic.nix {
    version = "17.5";
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
    hash = "sha256-/IjOnB8PUYpwqTmPPXhihSulIZsUf7uBx8HXSIlArM0=";
  };
  doInstallCheck = false;
})
