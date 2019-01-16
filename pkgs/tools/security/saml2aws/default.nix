{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "saml2aws-${version}";
  version = "2.13.0";

  goPackagePath = "github.com/versent/saml2aws";
  goDeps = ./deps.nix;

  buildFlagsArray = ''
    -ldflags=-X main.Version=${version}
  '';

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "Versent";
    repo = "saml2aws";
    sha256 = "1j2jbnyxj7v23j1a6a0f380hymssjq19h1kf6v0ycacy2s155gci";
  };

  meta = with stdenv.lib; {
    description = "CLI tool which enables you to login and retrieve AWS temporary credentials using a SAML IDP";
    homepage    = https://github.com/Versent/saml2aws;
    license     = licenses.mit;
    platforms   = with stdenv.lib.platforms; linux ++ darwin;
    maintainers = with stdenv.lib.maintainers; [ pmyjavec swdunlop ];
  };
}
