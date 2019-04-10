{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "saml2aws-${version}";
  version = "2.10.0";

  goPackagePath = "github.com/versent/saml2aws";
  goDeps = ./deps.nix;

  buildFlagsArray = ''
    -ldflags=-X main.Version=${version}
  '';

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "Versent";
    repo = "saml2aws";
    sha256 = "00m8x57fgry601w5f9dxnxdqbbqjiv7c0rsx47iv9qsp0w7l50c5";
  };

  meta = with stdenv.lib; {
    description = "CLI tool which enables you to login and retrieve AWS temporary credentials using a SAML IDP";
    homepage    = https://github.com/Versent/saml2aws;
    license     = licenses.mit;
    platforms   = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.pmyjavec ];
  };
}
