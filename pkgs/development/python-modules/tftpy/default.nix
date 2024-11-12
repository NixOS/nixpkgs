{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "tftpy";
  version = "0.8.2";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-4dGmgO/YjroXazURdYRCUwZzkqmw+LgViOP/K557u1s=";
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
