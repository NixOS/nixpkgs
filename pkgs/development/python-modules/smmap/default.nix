{
  lib,
  fetchPypi,
  buildPythonPackage,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "smmap";
  version = "5.0.3";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-TZ3ruLmQB65HFlq8CGcL10y3S1In3af2Q+zMTp61ZCw=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "smmap" ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    description = "Pure python implementation of a sliding window memory map manager";
    homepage = "https://github.com/gitpython-developers/smmap";
    maintainers = [ ];
    license = lib.licenses.bsd3;
  };
}
