{ lib, stdenv, buildGoModule, fetchFromGitHub, AppKit }:

buildGoModule rec {
  pname = "saml2aws";
  version = "2.36.13";

  src = fetchFromGitHub {
    owner = "Versent";
    repo = "saml2aws";
    rev = "v${version}";
    sha256 = "sha256-cLH1GcMgTPnPJVpHOQkW71hf0MKusL8NRc1YQsNSW2I=";
  };

  vendorHash = "sha256-E3WYExtV4VsrBZ0uEQZ36CUCK+qf8LTPlNwcdO0eEzA=";

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
