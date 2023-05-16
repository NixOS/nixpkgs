{ lib, stdenv, buildGoModule, fetchFromGitHub, AppKit }:

buildGoModule rec {
  pname = "saml2aws";
<<<<<<< HEAD
  version = "2.36.10";
=======
  version = "2.36.7";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "Versent";
    repo = "saml2aws";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-YoQ22AJOpNW7WVy9lCb/KzZ7/CkOMHSsgzh0gAfnqP0=";
  };

  vendorHash = "sha256-hbsURcFOLYP//1UXmxWfnNEb6PqJDqwAjJc5Au5+BOQ=";
=======
    sha256 = "sha256-Z+rudexDydpM/pExs6TvVTm03qIATf7uLRTQZKgBnLw=";
  };

  vendorHash = "sha256-h4jPaST15EsoWLsnTkO0GQDC+cTySMCyVnWFrdXeVDg=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  buildInputs = lib.optionals stdenv.isDarwin [ AppKit ];

  subPackages = [ "." "cmd/saml2aws" ];

  ldflags = [
    "-X main.Version=${version}"
  ];

  meta = with lib; {
    description = "CLI tool which enables you to login and retrieve AWS temporary credentials using a SAML IDP";
    homepage    = "https://github.com/Versent/saml2aws";
    license     = licenses.mit;
<<<<<<< HEAD
=======
    platforms   = lib.platforms.unix;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    maintainers = [ lib.maintainers.pmyjavec ];
  };
}
