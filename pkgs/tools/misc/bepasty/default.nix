<<<<<<< HEAD
{ lib
, python3
, fetchPypi
}:
#We need to use buildPythonPackage here to get the PYTHONPATH build correctly.
#This is needed for services.bepasty
#https://github.com/NixOS/nixpkgs/pull/38300
with python3.pkgs; buildPythonPackage rec {
  pname = "bepasty";
  version = "1.1.0";
=======
{ python3
, lib
}:

let
  python = python3.override {
    self = python;
    packageOverrides = self: super : {
      xstatic-bootstrap = super.xstatic-bootstrap.overridePythonAttrs(oldAttrs: rec {
        version = "3.3.7.1";
        src = oldAttrs.src.override {
          inherit version;
          sha256 = "0cgihyjb9rg6r2ddpzbjm31y0901vyc8m9h3v0zrhxydx1w9x50c";
        };
      });
    };
  };

#We need to use buildPythonPackage here to get the PYTHONPATH build correctly.
#This is needed for services.bepasty
#https://github.com/NixOS/nixpkgs/pull/38300
in with python.pkgs; buildPythonPackage rec {
  pname = "bepasty";
  version = "0.5.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  propagatedBuildInputs = [
    flask
    pygments
    setuptools
    xstatic
<<<<<<< HEAD
    xstatic-asciinema-player
    xstatic-bootbox
    xstatic-bootstrap
    xstatic-font-awesome
=======
    xstatic-bootbox
    xstatic-bootstrap
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    xstatic-jquery
    xstatic-jquery-file-upload
    xstatic-jquery-ui
    xstatic-pygments
  ];

  buildInputs = [ setuptools-scm ];

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    sha256 = "sha256-f5tRq48tCqjzOGq7Z2T2U1zwQN121N9ap+xPxHWZyvU=";
=======
    sha256 = "1y3smw9620w2ia4zfsl2svb9j7mkfgc8z1bzjffyk1w5vryhwikh";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeCheckInputs = [
    pytest
    selenium
  ];

  # No tests in sdist
  doCheck = false;

  meta = {
    homepage = "https://github.com/bepasty/bepasty-server";
    description = "Binary pastebin server";
<<<<<<< HEAD
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ aither64 makefu ];
=======
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.makefu ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
