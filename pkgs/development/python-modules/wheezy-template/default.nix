{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "wheezy.template";
  version = "3.2.2";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-hknPXHGPPNjRAr0TYVosPaTntsjwQjOKZBCU+qFlIHw=";
  };

  pythonImportsCheck = [ "wheezy.template" ];

  meta = with lib; {
    homepage = "https://wheezytemplate.readthedocs.io/en/latest/";
    description = "A lightweight template library";
    mainProgram = "wheezy.template";
    license = licenses.mit;
    maintainers = with maintainers; [ lilyinstarlight ];
  };
}
