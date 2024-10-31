{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  wheel,
  docutils,
  sphinx,
}:

buildPythonPackage rec {
  pname = "sphinx-togglebutton";
  version = "0.3.2";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-qwyLNmQnsB5MiYAtXQeEcsQn+m6dEtUhw0+gRCVZ3Ho=";
  };

  nativeBuildInputs = [
    setuptools
    wheel
  ];

  propagatedBuildInputs = [
    docutils
    sphinx
  ];

  pythonImportsCheck = [ "sphinx_togglebutton" ];

  meta = with lib; {
    description = "Toggle page content and collapse admonitions in Sphinx";
    homepage = "https://github.com/executablebooks/sphinx-togglebutton";
    license = licenses.mit;
    maintainers = [ ];
  };
}
