{ lib
, buildPythonPackage
, fetchPypi

, unittestCheckHook

, setuptools
}:

buildPythonPackage rec {
  pname = "tinysegmenter";
  version = "0.3";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-7R9tLoBqR1inO+WJdUOEy62tx+GkFMgaFm/JrfLUDG0=";
  };

  build-system = [
    setuptools
  ];

  nativeCheckInputs = [
    unittestCheckHook
  ];

  unittestFlagsArray = [ "-s" "tests" ];

  pythonImportsCheck = [ "tinysegmenter" ];

  meta = with lib; {
    description = "Very compact Japanese tokenizer";
    homepage = "https://tinysegmenter.tuxfamily.org";
    license = licenses.bsd3;
    maintainers = with maintainers; [ vizid ];
  };
}
