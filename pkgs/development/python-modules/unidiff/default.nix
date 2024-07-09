{
  lib,
  buildPythonPackage,
  fetchPypi,
  unittestCheckHook,
}:

buildPythonPackage rec {
  pname = "unidiff";
  version = "0.7.5";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "2e5f0162052248946b9f0970a40e9e124236bf86c82b70821143a6fc1dea2574";
  };

  nativeCheckInputs = [ unittestCheckHook ];

  unittestFlagsArray = [
    "-s"
    "tests"
  ];

  pythonImportsCheck = [ "unidiff" ];

  meta = with lib; {
    description = "Unified diff python parsing/metadata extraction library";
    mainProgram = "unidiff";
    homepage = "https://github.com/matiasb/python-unidiff";
    changelog = "https://github.com/matiasb/python-unidiff/raw/v${version}/HISTORY";
    license = licenses.mit;
    maintainers = [ maintainers.pbsds ];
  };
}
