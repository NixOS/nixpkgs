{ lib, stdenv, buildGoModule, fetchFromGitHub, AppKit }:

buildGoModule rec {
  pname = "saml2aws";
  version = "2.33.0";

  src = fetchFromGitHub {
    owner = "Versent";
    repo = "saml2aws";
    rev = "v${version}";
    sha256 = "sha256-99URhGJJKO4l+ztMGljiuNKVTYIG2iyWUMBXG1WTPdI=";
  };

  vendorSha256 = "sha256-oUEgJ1DDzhKUpYevylIr+1X28xFGaWMh5+q1HTqOHaU=";

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
