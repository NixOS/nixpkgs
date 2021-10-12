{ lib, stdenv, buildGoModule, fetchFromGitHub, AppKit }:

buildGoModule rec {
  pname = "saml2aws";
  version = "2.32.0";

  src = fetchFromGitHub {
    owner = "Versent";
    repo = "saml2aws";
    rev = "v${version}";
    sha256 = "sha256-VMNK6kmMPe1Qwfb/NmMaBhtdqg59KmtiankVNZmhNdY=";
  };

  runVend = true;
  vendorSha256 = "sha256-2tu3wSp9N+icpKvDeUgzYRLc6jXivn1D0jX/5LSgwNw=";

  buildInputs = lib.optionals stdenv.isDarwin [ AppKit ];

  doCheck = false;

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
