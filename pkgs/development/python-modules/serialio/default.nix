{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  pyserial,
  sockio,
}:

buildPythonPackage rec {
  pname = "serialio";
  version = "2.4.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "tiagocoutinho";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-9TRGT0wpoRRcHqnH1XzlMBh0IcVzdEcOzN7hkeYnoW4=";
  };

  propagatedBuildInputs = [
    pyserial
    sockio
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "serialio" ];

  meta = with lib; {
    description = "Library for concurrency agnostic serial communication";
    homepage = "https://github.com/tiagocoutinho/serialio";
    license = with licenses; [ gpl3Plus ];
    maintainers = with maintainers; [ fab ];
  };
}
