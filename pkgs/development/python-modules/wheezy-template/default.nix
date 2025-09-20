{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "wheezy.template";
  version = "3.2.2";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-hknPXHGPPNjRAr0TYVosPaTntsjwQjOKZBCU+qFlIHw=";
  };

  pythonImportsCheck = [ "wheezy.template" ];

  meta = {
    homepage = "https://wheezytemplate.readthedocs.io/en/latest/";
    description = "Lightweight template library";
    mainProgram = "wheezy.template";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
