{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "saml2aws";
  version = "2.30.0";

  src = fetchFromGitHub {
    owner = "Versent";
    repo = "saml2aws";
    rev = "v${version}";
    sha256 = "0plwh7dswf756xy048dqycc2nlpnzk3d1s9m6ypgi77vydryzhj3";
  };

  runVend = true;
  vendorSha256 = lib.fakeSha256;

  doCheck = false;

  subPackages = [ "." "cmd/saml2aws" ];

  buildFlagsArray = ''
    -v
    -trimpath
    -ldflags=-s -w -X main.Version=${version} -X main.commit=${src.sha256}
  '';

  meta = with lib; {
    description = "CLI tool which enables you to login and retrieve AWS temporary credentials using a SAML IDP";
    homepage    = "https://github.com/Versent/saml2aws";
    license     = licenses.mit;
    platforms   = lib.platforms.unix;
    maintainers = [ lib.maintainers.pmyjavec ];
  };
}
