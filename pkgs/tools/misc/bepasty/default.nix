{ python3Packages
, lib
}:

with python3Packages;

#We need to use buildPythonPackage here to get the PYTHONPATH build correctly.
#This is needed for services.bepasty
#https://github.com/NixOS/nixpkgs/pull/38300
buildPythonPackage rec {
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

  meta = {
    homepage = https://github.com/bepasty/bepasty-server;
    description = "Binary pastebin server";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.makefu ];
  };
}
