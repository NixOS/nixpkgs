{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "lego";
  version = "3.7.0";

  src = fetchFromGitHub {
    owner = "go-acme";
    repo = pname;
    rev = "v${version}";
    sha256 = "03824c5nfii7cc6mr1hdkyd4jjy8vpn08lnj4c6pc61s3i6gacc6";
  };

  vendorSha256 = "14453iiya6algkympyvwm03qgjcwk79z8bbrij7qhnp52qfrbmrp";
  subPackages = [ "cmd/lego" ];

  buildFlagsArray = [
    "-ldflags=-X main.version=${version}"
  ];

  meta = with lib; {
    description = "Let's Encrypt client and ACME library written in Go";
    license = licenses.mit;
    homepage = "https://go-acme.github.io/lego/";
    maintainers = teams.acme.members;
  };
}
