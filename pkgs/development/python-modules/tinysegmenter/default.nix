{
  lib,
  buildPythonPackage,
  fetchPypi,

  unittestCheckHook,

  setuptools,
}:

buildPythonPackage rec {
  pname = "tinysegmenter";
  version = "0.4";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ZEWL26VLp0gsAseF+WDPPWz2FZSk2rPWTDJUOQlPwbc=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ unittestCheckHook ];

  unittestFlagsArray = [
    "-s"
    "tests"
  ];

  pythonImportsCheck = [ "tinysegmenter" ];

  meta = with lib; {
    description = "Very compact Japanese tokenizer";
    homepage = "https://tinysegmenter.tuxfamily.org";
    license = licenses.bsd3;
    maintainers = with maintainers; [ vizid ];
  };
}
