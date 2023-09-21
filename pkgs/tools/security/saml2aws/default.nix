{ lib, stdenv, buildGoModule, fetchFromGitHub, AppKit }:

buildGoModule rec {
  pname = "saml2aws";
  version = "2.36.10";

  src = fetchFromGitHub {
    owner = "Versent";
    repo = "saml2aws";
    rev = "v${version}";
    sha256 = "sha256-YoQ22AJOpNW7WVy9lCb/KzZ7/CkOMHSsgzh0gAfnqP0=";
  };

  vendorHash = "sha256-hbsURcFOLYP//1UXmxWfnNEb6PqJDqwAjJc5Au5+BOQ=";

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
