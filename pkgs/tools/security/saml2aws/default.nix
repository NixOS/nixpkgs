{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "saml2aws-${version}";
  pname = "saml2aws";
  version = "2.15.0";

  goPackagePath = "github.com/versent/saml2aws";
  goDeps = ./deps.nix;

  buildFlagsArray = ''
    -ldflags=-X main.Version=${version}
  '';

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "Versent";
    repo = "saml2aws";
    sha256 = "0pn4zdzisgan7vvgi7hp8716wsb2x33gq55c7fw1aa2qwy0bq3gp";
  };

  meta = with stdenv.lib; {
    description = "CLI tool which enables you to login and retrieve AWS temporary credentials using a SAML IDP";
    homepage    = https://github.com/Versent/saml2aws;
    license     = licenses.mit;
    platforms   = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.pmyjavec ];
  };
}
