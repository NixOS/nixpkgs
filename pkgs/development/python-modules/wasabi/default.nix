{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,

  # tests
  ipykernel,
  nbconvert,
  pytestCheckHook,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "wasabi";
  version = "1.1.2";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Gq7zrOqjLtuckTMNKdOTbAw5/blldDVJwXPLVLFsMLU=";
  };

  nativeCheckInputs = [
    ipykernel
    nbconvert
    typing-extensions
    pytestCheckHook
  ];

  pythonImportsCheck = [ "wasabi" ];

  meta = with lib; {
    description = "A lightweight console printing and formatting toolkit";
    homepage = "https://github.com/ines/wasabi";
    changelog = "https://github.com/ines/wasabi/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
