{ lib
, fetchPypi
, buildPythonPackage
, pythonOlder
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "semantic-version";
  version = "2.10.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "semantic_version";
    inherit version;
    hash = "sha256-vau20zaZjLs3jUuds6S1ah4yNXAdwF6iaQ2amX7VBBw=";
  };

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "semantic_version"
  ];

  meta = with lib; {
    description = "A library implementing the 'SemVer' scheme";
    homepage = "https://github.com/rbarrois/python-semanticversion/";
    license = licenses.bsd2;
    maintainers = with maintainers; [ layus makefu ];
  };
}
