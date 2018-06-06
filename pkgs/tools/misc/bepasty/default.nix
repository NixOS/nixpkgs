{ python
, lib
}:

with python.pkgs;

#We need to use buildPythonPackage here to get the PYTHONPATH build correctly.
#This is needed for services.bepasty
#https://github.com/NixOS/nixpkgs/pull/38300
buildPythonPackage rec {
  pname = "bepasty";
  version = "0.4.0";

  propagatedBuildInputs = [
    flask
    pygments
    xstatic
    xstatic-bootbox
    xstatic-bootstrap
    xstatic-jquery
    xstatic-jquery-file-upload
    xstatic-jquery-ui
    xstatic-pygments
  ];
  src = fetchPypi {
    inherit pname version;
    sha256 = "0bs79pgrjlnkmjfyj2hllbx3rw757va5w2g2aghi9cydmsl7gyi4";
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
