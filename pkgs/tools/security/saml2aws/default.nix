{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "saml2aws";
  version = "2.28.3";

  src = fetchFromGitHub {
    owner = "Versent";
    repo = "saml2aws";
    rev = "v${version}";
    sha256 = "sha256-2bHLSODCCQ+IpUTb81QiUPY2XGKn0eElWUltfgVfk1U=";
  };

  runVend = true;
  vendorSha256 = "sha256-4q7hEvF12Rzk3eJEjLc0rsxeWcwsWKkg9mB5ohYgG0U=";

  doCheck = false;

  subPackages = [ "." "cmd/saml2aws" ];

  buildFlagsArray = ''
    -ldflags=-X main.Version=${version}
  '';

  meta = with lib; {
    description = "CLI tool which enables you to login and retrieve AWS temporary credentials using a SAML IDP";
    homepage    = "https://github.com/Versent/saml2aws";
    license     = licenses.mit;
    platforms   = lib.platforms.unix;
    maintainers = [ lib.maintainers.pmyjavec ];
  };
}
