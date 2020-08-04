{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "saml2aws";
  version = "2.26.2";

  src = fetchFromGitHub {
    owner = "Versent";
    repo = "saml2aws";
    rev = "v${version}";
    sha256 = "0y5gvdrdr6i9spdwsxvzs1bxs32icxpkqxnglp1bf4gglc580d87";
  };

  runVend = true;
  vendorSha256 = "1kzihyx44sx6php4z58fzy6c3g0y713939yzxpgk3n03snn2x8sf";

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
