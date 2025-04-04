{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "tftpy";
  version = "0.8.5";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-3TjjdEUw0MMPoccV1/pFQxm8jTmbtAwFg5zHcfBdDmw=";
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
