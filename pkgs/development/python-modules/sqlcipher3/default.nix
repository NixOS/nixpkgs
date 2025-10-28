{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  sqlcipher,
  openssl,
}:
let
  pname = "sqlcipher3";
  version = "0.5.4";
in
buildPythonPackage {
  inherit pname version;
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-4w/1jWTdQ+Gezt3RARahonrR2YiMxCRcdfK9qbA4Tnc=";
  };

  build-system = [
    setuptools
  ];

  buildInputs = [
    sqlcipher
    openssl
  ];

  pythonImportsCheck = [
    "sqlcipher3"
  ];

  meta = with lib; {
    mainProgram = "sqlcipher3";
    homepage = "https://github.com/coleifer/sqlcipher3";
    description = "Python 3 bindings for SQLCipher";
    license = licenses.zlib;
    maintainers = with maintainers; [ phaer ];
  };
}
