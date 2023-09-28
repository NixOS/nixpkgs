{ lib
, python3
, fetchPypi
}:
let
  # bepasty 1.2 needs xstatic-font-awesome < 5, see
  # https://github.com/bepasty/bepasty-server/issues/305
  bepastyPython = python3.override {
    self = bepastyPython;
    packageOverrides = self: super: {
      xstatic-font-awesome = super.xstatic-font-awesome.overridePythonAttrs(oldAttrs: rec {
        version = "4.7.0.0";
        src = oldAttrs.src.override {
          inherit version;
          sha256 = "sha256-4B+0gMqqfHlj3LMyikcA5jG+9gcNsOi2hYFtIg5oX2w=";
        };
      });
    };
  };

#We need to use buildPythonPackage here to get the PYTHONPATH build correctly.
#This is needed for services.bepasty
#https://github.com/NixOS/nixpkgs/pull/38300
in with bepastyPython.pkgs; buildPythonPackage rec {
  pname = "bepasty";
  version = "1.2.0";
  format = "pyproject";

  propagatedBuildInputs = [
    flask
    markupsafe
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
    sha256 = "sha256-R3bvrl/tOP0S9m6X+MwYK6fMQ51cI6W5AoxyYZ8aZ/w=";
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
