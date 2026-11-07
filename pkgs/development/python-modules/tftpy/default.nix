{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "tftpy";
  version = "0.8.7";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-6KWqCS2rLhy7m5Q5IDaCe4CNw362zxsaszyBlXs/X+I=";
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
