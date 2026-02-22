let
  neonRev = "a42351fcd41ea01edede1daed65f651e838988fc";
  base = import ./generic.nix {
    version = "16.9";
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
    hash = "sha256-G1FsFBeVFxUotk4b6oAYPz/DCjXCnirXQBZA77eaeIg=";
  };
  doInstallCheck = false;
})
