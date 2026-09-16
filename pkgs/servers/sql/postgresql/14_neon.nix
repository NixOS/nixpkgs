let
  neonRev = "2155cb165d05f617eb2c8ad7e43367189b627703";
  base = import ./generic.nix {
    version = "14.18";
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
    hash = "sha256-bPAHFkkNB0J9fimYJ2RYflN1zOGsAcOD0VHGfMEex7g=";
  };
  doInstallCheck = false;
})
