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

<<<<<<< HEAD
  meta = {
    homepage = "https://wheezytemplate.readthedocs.io/en/latest/";
    description = "Lightweight template library";
    mainProgram = "wheezy.template";
    license = lib.licenses.mit;
=======
  meta = with lib; {
    homepage = "https://wheezytemplate.readthedocs.io/en/latest/";
    description = "Lightweight template library";
    mainProgram = "wheezy.template";
    license = licenses.mit;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    maintainers = [ ];
  };
}
