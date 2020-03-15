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

  propagatedBuildInputs = [
    flask
    pygments
    setuptools
    xstatic
    xstatic-bootbox
    xstatic-bootstrap
    xstatic-jquery
    xstatic-jquery-file-upload
    xstatic-jquery-ui
    xstatic-pygments
  ];

  buildInputs = [ setuptools_scm ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "1y3smw9620w2ia4zfsl2svb9j7mkfgc8z1bzjffyk1w5vryhwikh";
  };

  checkInputs = [
    pytest
    selenium
  ];

  # No tests in sdist
  doCheck = false;

  meta = {
    homepage = https://github.com/bepasty/bepasty-server;
    description = "Binary pastebin server";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.makefu ];
  };
}
