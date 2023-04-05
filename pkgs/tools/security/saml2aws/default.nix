{ lib, stdenv, buildGoModule, fetchFromGitHub, AppKit }:

buildGoModule rec {
  pname = "saml2aws";
  version = "2.36.5";

  src = fetchFromGitHub {
    owner = "Versent";
    repo = "saml2aws";
    rev = "v${version}";
    sha256 = "sha256-v5lr0CtKBDNB3Cy9/3mA6E0koQyQvtGe1ET2Mm4EfDc=";
  };

  vendorHash = "sha256-MXm1V8GrjZn/x0Q6fW8zJN351zVsPGME4eFg6f8cEX8=";

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
