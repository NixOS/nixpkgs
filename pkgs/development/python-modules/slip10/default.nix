{
  lib,
  buildPythonPackage,
  fetchPypi,
  poetry-core,
  base58,
  cryptography,
  ecdsa,
}:

buildPythonPackage rec {
  pname = "slip10";
  version = "1.0.1";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ArNQrlV7WReRQosXVR+V16xX6SEfN969yBTJC0oSOlQ=";
  };

  build-system = [ poetry-core ];

  propagatedBuildInputs = [
    base58
    cryptography
    ecdsa
  ];

  pythonImportsCheck = [ "slip10" ];

  meta = with lib; {
    description = "Minimalistic implementation of SLIP109";
    homepage = "https://github.com/trezor/python-slip10";
    license = licenses.bsd3;
    maintainers = with maintainers; [
      prusnak
    ];
  };
}
