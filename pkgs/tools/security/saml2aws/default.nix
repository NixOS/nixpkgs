{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "saml2aws-${version}";
  version = "2.6.1";

  goPackagePath = "github.com/versent/saml2aws";
  goDeps = ./deps.nix;

  buildFlagsArray = ''
    -ldflags=-X main.Version=${version}
  '';

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "Versent";
    repo = "saml2aws";
    sha256 = "0sg5qm1gyrisna247lmxfgpa22y6rnz9vd6yg92kxlcwr4ji8l1j";
  };

  meta = with stdenv.lib; {
    description = "CLI tool which enables you to login and retrieve AWS temporary credentials using a SAML IDP";
    homepage    = https://github.com/Versent/saml2aws;
    license     = licenses.mit;
    platforms   = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.pmyjavec ];
  };
}
