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
<<<<<<< HEAD
  version = "0.6.0";
=======
  version = "0.5.4";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
in
buildPythonPackage {
  inherit pname version;
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-o1GuYwvWFMLBDtiYtCD3vIF+Q4FT9oP4g0jERdazqbE=";
=======
    hash = "sha256-4w/1jWTdQ+Gezt3RARahonrR2YiMxCRcdfK9qbA4Tnc=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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

<<<<<<< HEAD
  meta = {
    mainProgram = "sqlcipher3";
    homepage = "https://github.com/coleifer/sqlcipher3";
    description = "Python 3 bindings for SQLCipher";
    license = lib.licenses.zlib;
    maintainers = with lib.maintainers; [ phaer ];
=======
  meta = with lib; {
    mainProgram = "sqlcipher3";
    homepage = "https://github.com/coleifer/sqlcipher3";
    description = "Python 3 bindings for SQLCipher";
    license = licenses.zlib;
    maintainers = with maintainers; [ phaer ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
