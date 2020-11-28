{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "saml2aws";
  version = "2.27.1";

  src = fetchFromGitHub {
    owner = "Versent";
    repo = "saml2aws";
    rev = "v${version}";
    sha256 = "1ffq7jh14cj45wn5rx9awh5k8hqbfwm4fjz0a0rq22yqfwbbkkj2";
  };

  runVend = true;
  vendorSha256 = "1w7vnpv36lhxpaljdhslbckkr7p81nzc91a0503wk8nrrc4ljsyy";

  doCheck = false;

  subPackages = [ "." "cmd/saml2aws" ];

  buildFlagsArray = ''
    -ldflags=-X main.Version=${version}
  '';

  meta = with stdenv.lib; {
    description = "CLI tool which enables you to login and retrieve AWS temporary credentials using a SAML IDP";
    homepage    = "https://github.com/Versent/saml2aws";
    license     = licenses.mit;
    platforms   = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.pmyjavec ];
  };
}
