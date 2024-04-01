{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "go-toml";
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "pelletier";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-oXFZoGAlHRGGqbjjyI0pz1fIg8h6GN0SKOyRQyS4UA0=";
  };

  vendorHash = "sha256-4t/ft3XTfc7yrsFVMSfjdCur8QULho3NI2ym6gqjexI=";

  excludedPackages = [
    "cmd/gotoml-test-decoder"
    "cmd/gotoml-test-encoder"
    "cmd/tomltestgen"
  ];

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    description = "Go library for the TOML language";
    homepage = "https://github.com/pelletier/go-toml";
    changelog = "https://github.com/pelletier/go-toml/releases/tag/v${version}";
    maintainers = [ maintainers.marsam ];
    license = licenses.mit;
  };
}
