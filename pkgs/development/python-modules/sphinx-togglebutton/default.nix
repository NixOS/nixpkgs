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
  version = "0.4.4";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-BMMyaS/V9TY60CoAHmkzaXZ9bB8OWCeXcKKutXG0cqE=";
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

  meta = {
    description = "Toggle page content and collapse admonitions in Sphinx";
    homepage = "https://github.com/executablebooks/sphinx-togglebutton";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
