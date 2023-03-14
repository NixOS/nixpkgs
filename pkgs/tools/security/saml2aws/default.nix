{ lib, stdenv, buildGoModule, fetchFromGitHub, AppKit }:

buildGoModule rec {
  pname = "saml2aws";
  version = "2.36.4";

  src = fetchFromGitHub {
    owner = "Versent";
    repo = "saml2aws";
    rev = "v${version}";
    sha256 = "sha256-bUXiF+GlmNe8zoEjC8aWsbKEnymUKQv+121dTUVtqEQ=";
  };

  vendorHash = "sha256-APwtLd8+Imy4cBSlm4sHPdA/DQCN4pDFSM/R5ib3k4E=";

  buildInputs = lib.optionals stdenv.isDarwin [ AppKit ];

  subPackages = [ "." "cmd/saml2aws" ];

  ldflags = [
    "-X main.Version=${version}"
  ];

  meta = with lib; {
    description = "CLI tool which enables you to login and retrieve AWS temporary credentials using a SAML IDP";
    homepage    = "https://github.com/Versent/saml2aws";
    license     = licenses.mit;
    platforms   = lib.platforms.unix;
    maintainers = [ lib.maintainers.pmyjavec ];
  };
}
