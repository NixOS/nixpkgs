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

  propagatedBuildInputs = [
    flask
    pygments
    setuptools
    xstatic
    xstatic-asciinema-player
    xstatic-bootbox
    xstatic-bootstrap
    xstatic-font-awesome
    xstatic-jquery
    xstatic-jquery-file-upload
    xstatic-jquery-ui
    xstatic-pygments
  ];

  buildInputs = [ setuptools-scm ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-f5tRq48tCqjzOGq7Z2T2U1zwQN121N9ap+xPxHWZyvU=";
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
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ aither64 makefu ];
  };
}
