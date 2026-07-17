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
  version = "0.4.5";
  pyproject = true;

  src = fetchPypi {
    inherit version;
    pname = "sphinx_togglebutton";
    hash = "sha256-yHDfvTvG4Rm1D/mjemT4mRkCJp6FZyiTHH2Jh36NSz0=";
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
