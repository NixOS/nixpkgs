{ lib, buildPythonPackage, fetchPypi, unittestCheckHook }:

buildPythonPackage rec {
  pname = "unidiff";
  version = "0.7.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "2bbcbc986e1fb97f04b1d7b864aa6002ab02f4d8a996bf03aa6e5a81447d1fc5";
  };

  checkInputs = [ unittestCheckHook ];

  unittestFlagsArray = [ "-s" "tests" ];

  pythonImportsCheck = [ "unidiff" ];

  meta = with lib; {
    description = "Unified diff python parsing/metadata extraction library";
    homepage = "https://github.com/matiasb/python-unidiff";
    changelog = "https://github.com/matiasb/python-unidiff/raw/v${version}/HISTORY";
    license = licenses.mit;
    maintainers = [ maintainers.marsam ];
  };
}
