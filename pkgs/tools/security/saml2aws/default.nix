{ lib, stdenv, buildGoModule, fetchFromGitHub, AppKit }:

buildGoModule rec {
  pname = "saml2aws";
  version = "2.36.11";

  src = fetchFromGitHub {
    owner = "Versent";
    repo = "saml2aws";
    rev = "v${version}";
    sha256 = "sha256-Sx/MAgjPcUzg4sX0O3CobAXCZQi2msZu6dKZ9q7/K+k=";
  };

  vendorHash = "sha256-T5x8C1cKyJaHVJbf2xNabD3XXwde2lOOCa8GHjdFlh0=";

  buildInputs = lib.optionals stdenv.isDarwin [ AppKit ];

  subPackages = [ "." "cmd/saml2aws" ];

  ldflags = [
    "-X main.Version=${version}"
  ];

  meta = with lib; {
    description = "CLI tool which enables you to login and retrieve AWS temporary credentials using a SAML IDP";
    homepage    = "https://github.com/Versent/saml2aws";
    license     = licenses.mit;
    maintainers = [ lib.maintainers.pmyjavec ];
  };
}
