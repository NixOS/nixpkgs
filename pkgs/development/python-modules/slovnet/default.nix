{
  lib,
  buildPythonPackage,
  fetchPypi,
  numpy,
  razdel,
  navec,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "slovnet";
  version = "0.6.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-AtIle9ybnMHSQr007iyGHGSPcIPveJj+FGirzDge95k=";
  };

  propagatedBuildInputs = [
    numpy
    navec
    razdel
  ];
  nativeCheckInputs = [ pytestCheckHook ];
  enabledTestPaths = [ "tests/" ];
  disabledTestPaths = [
    # Tries to download model binary artifacts:
    "tests/test_api.py"
  ];
  pythonImportsCheck = [ "slovnet" ];

<<<<<<< HEAD
  meta = {
    description = "Deep-learning based NLP modeling for Russian language";
    homepage = "https://github.com/natasha/slovnet";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ npatsakula ];
=======
  meta = with lib; {
    description = "Deep-learning based NLP modeling for Russian language";
    homepage = "https://github.com/natasha/slovnet";
    license = licenses.mit;
    maintainers = with maintainers; [ npatsakula ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
