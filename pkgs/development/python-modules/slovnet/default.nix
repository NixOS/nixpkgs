{ lib
, buildPythonPackage
, fetchPypi
, numpy
, razdel
, navec
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "slovnet";
  version = "0.6.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-AtIle9ybnMHSQr007iyGHGSPcIPveJj+FGirzDge95k=";
  };

  propagatedBuildInputs = [ numpy navec razdel ];
  nativeCheckInputs = [ pytestCheckHook ];
  pytestFlagsArray = [ "tests/" ];
  disabledTestPaths = [
    # Tries to download model binary artifacts:
    "tests/test_api.py"
  ];
  pythonImportCheck = [ "slovnet" ];

  meta = with lib; {
    description = "Deep-learning based NLP modeling for Russian language";
    homepage = "https://github.com/natasha/slovnet";
    license = licenses.mit;
    maintainers = with maintainers; [ npatsakula ];
  };
}
