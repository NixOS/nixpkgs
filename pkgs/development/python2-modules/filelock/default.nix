{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "filelock";
  version = "3.2.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1qry67zv2pmz8px6wdfbjqv75nmryy2ac7asqgs6q6db2722kpcw";
  };

  nativeBuildInputs = [
    setuptools-scm
  ];

  meta = {
    homepage = "https://github.com/benediktschmitt/py-filelock";
    description = "Platform independent file lock for Python";
    license = lib.licenses.unlicense;
    maintainers = with lib.maintainers; [ henkkalkwater ];
  };
}
