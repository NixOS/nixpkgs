{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "go-toml";
  version = "2.0.6";

  src = fetchFromGitHub {
    owner = "pelletier";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-RXKJJseRrwSTReMAkFjShKvCWGMowruYwsCovHwq4ZQ=";
  };

  vendorSha256 = "sha256-MMCyFKqsL9aSQqK9VtPzUbgfLTFpzD5g8QYx8qIwktg=";

  excludedPackages = [ "cmd/gotoml-test-decoder" "cmd/tomltestgen" ];

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    description = "Go library for the TOML language";
    homepage = "https://github.com/pelletier/go-toml";
    maintainers = [ maintainers.marsam ];
    license = licenses.mit;
  };
}
