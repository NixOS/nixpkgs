{ lib, stdenv, buildGoModule, fetchFromGitHub, AppKit }:

buildGoModule rec {
  pname = "saml2aws";
  version = "2.36.12";

  src = fetchFromGitHub {
    owner = "Versent";
    repo = "saml2aws";
    rev = "v${version}";
    sha256 = "sha256-egsAUaGYe06hlPUE4J4acdrfMlDEY/8g0g9KPPJyMlI=";
  };

  vendorHash = "sha256-hdt/XhxMuR6YlvY/Qu2AjY5F75YvYLlv0LfuMwJQkl4=";

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
