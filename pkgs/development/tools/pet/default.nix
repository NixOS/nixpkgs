{ buildGoPackage, fetchFromGitHub, lib }:

buildGoPackage rec {
  name = "pet-${version}";
  version = "0.3.2";

  goPackagePath = "github.com/knqyf263/pet";

  src = fetchFromGitHub {
    owner = "knqyf263";
    repo = "pet";
    rev = "v${version}";
    sha256 = "1zv2jfgh5nqd4cwr1ljm5p4rqam7hq3a6asfmhr3lcnp7sz9b8fr";
  };

  goDeps = ./deps.nix;

  meta = with lib; {
    description = "Simple command-line snippet manager, written in Go";
    homepage = https://github.com/knqyf263/pet;
    license = licenses.mit;
    maintainers = with maintainers; [ kalbasit ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
