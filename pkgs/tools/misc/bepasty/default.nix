{ python
, lib
}:

with python.pkgs;

buildPythonApplication rec {
  pname = "bepasty";
  version = "0.4.0";
  name = "${pname}-${version}";

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

  meta = {
    homepage = https://github.com/bepasty/bepasty-server;
    description = "Binary pastebin server";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.makefu ];
  };
}