{
  lib,
  buildPythonPackage,
  fetchPypi,
  ordered-set,
  pyserial,
  setuptools,
}:
buildPythonPackage rec {
  pname = "ymodem";
  version = "1.5.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-5Dc81sjSlilJXb/92e0Yewfyc4EjHVXToTcCUyDVzmc=";
  };

  build-system = [ setuptools ];

  dependencies = [
    ordered-set
    pyserial
  ];

  # Module has no test
  doCheck = false;

  pythonImportsCheck = [ "ymodem" ];

  meta = {
    description = "YMODEM protocol implementation for Python";
    homepage = "https://github.com/alexwoo1900/ymodem";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ungeskriptet ];
    mainProgram = "ymodem";
  };
}
