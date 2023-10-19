{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "errcheck";
  version = "1.6.3";

  src = fetchFromGitHub {
    owner = "kisielk";
    repo = "errcheck";
    rev = "v${version}";
    hash = "sha256-t5ValY4I3RzsomJP7mJjJSN9wU1HLQrajxpqmrri/oU=";
  };

  vendorHash = "sha256-96+927gNuUMovR4Ru/8BwsgEByNq2EPX7wXWS7+kSL8=";

  subPackages = [ "." ];

  meta = with lib; {
    description = "Checks for unchecked errors in go programs";
    homepage = "https://github.com/kisielk/errcheck";
    license = licenses.mit;
    maintainers = with maintainers; [ kalbasit ];
  };
}
