{
  lib,
  fetchPypi,
  buildPythonPackage,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "smmap";
  version = "6.0.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-jXkCjqbMEx2l6rCZpdlamY1DxneZVv/+O0VQQJEQdto=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "smmap" ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    description = "A pure python implementation of a sliding window memory map manager";
    homepage = "https://github.com/gitpython-developers/smmap";
    maintainers = [ ];
    license = lib.licenses.bsd3;
  };
}
