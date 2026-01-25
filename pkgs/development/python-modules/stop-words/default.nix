{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  unittestCheckHook,
}:

buildPythonPackage rec {
  pname = "stop-words";
  version = "2025.11.4";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-BFkHK1SxHkOm+0xbBb2ofSrM/E8UwWl5dPNzmvD3tD0=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ unittestCheckHook ];

  pythonImportsCheck = [ "stop_words" ];

  meta = {
    description = "Get list of common stop words in various languages in Python";
    homepage = "https://github.com/Alir3z4/python-stop-words";
    license = [ lib.licenses.bsd3 ];
    maintainers = with lib.maintainers; [ lavafroth ];
  };
}
