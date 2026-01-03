{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "tftpy";
  version = "0.8.6";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-9hb2pDo21IHCZlc2CFl7ndPHxjgYQV1yqgTx0XlUgOo=";
  };

  nativeBuildInputs = [ setuptools ];

  pythonImportsCheck = [ "tftpy" ];

  meta = {
    description = "Pure Python TFTP library";
    homepage = "https://github.com/msoulier/tftpy";
    changelog = "https://github.com/msoulier/tftpy/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ otavio ];
  };
}
