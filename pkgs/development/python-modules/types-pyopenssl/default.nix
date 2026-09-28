{
  lib,
  buildPythonPackage,
  fetchPypi,
  cryptography,
}:

buildPythonPackage rec {
  pname = "types-pyopenssl";
  version = "24.1.0.20240722";
  format = "setuptools";

  src = fetchPypi {
    pname = "types-pyOpenSSL";
    inherit version;
    hash = "sha256-R5E7RnigHYefUDoSBERoIh7YV2JjwVQNywSEyiGwjDk=";
  };

  propagatedBuildInputs = [ cryptography ];

  # Module doesn't have tests
  doCheck = false;

  pythonImportsCheck = [ "OpenSSL-stubs" ];

  meta = {
    description = "Typing stubs for pyopenssl";
    homepage = "https://github.com/python/typeshed";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ gador ];
  };
}
