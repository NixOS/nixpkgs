{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pyserial,
  sockio,
}:

buildPythonPackage rec {
  pname = "serialio";
  version = "2.4.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "tiagocoutinho";
    repo = "serialio";
    tag = "v${version}";
    hash = "sha256-9TRGT0wpoRRcHqnH1XzlMBh0IcVzdEcOzN7hkeYnoW4=";
  };

  propagatedBuildInputs = [
    pyserial
    sockio
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "serialio" ];

  meta = {
    description = "Library for concurrency agnostic serial communication";
    homepage = "https://github.com/tiagocoutinho/serialio";
    license = with lib.licenses; [ gpl3Plus ];
    maintainers = with lib.maintainers; [ fab ];
  };
}
