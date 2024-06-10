{ lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "glock";
  version = "20160816-${lib.strings.substring 0 7 rev}";
  rev = "b8c84ff5ade15a6238ca61c20d3afc70d2e41276";

  goPackagePath = "github.com/robfig/glock";

  src = fetchFromGitHub {
    inherit rev;
    owner = "robfig";
    repo = "glock";
    sha256 = "10jwn3k71p340g8d43zjx7k1j534rcd7rss8pif09mpfrn9qndhh";
  };

  goDeps = ./deps.nix;

  meta = with lib; {
    homepage = "https://github.com/robfig/glock";
    description = "Command-line tool to lock Go dependencies to specific revisions";
    mainProgram = "glock";
    license = licenses.mit;
    maintainers = [ maintainers.rushmorem ];
  };
}
