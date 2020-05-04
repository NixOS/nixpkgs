{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "saml2aws";
  version = "2.25.0";

  src = fetchFromGitHub {
    owner = "Versent";
    repo = "saml2aws";
    rev = "v${version}";
    sha256 = "12aidylamrq4rvy2cfdz669lr1p20yqrshigcc5x1hrlhh9y64xc";
  };

  modSha256 = "1kcj5065yy52p1jy4fad5lsz3y4spqc40k1qsirm53qqixhrhvag";

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
