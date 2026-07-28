{
  lib,
  buildPythonPackage,
  fetchPypi,
  poetry-core,
  base58,
  cryptography,
}:

buildPythonPackage rec {
  pname = "slip10";
  version = "1.1.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-0kjT3ybxI/CEdDOcRfDyZCVPdK6aVlcjSh1euR8MTVQ=";
  };

  build-system = [ poetry-core ];

  propagatedBuildInputs = [
    base58
    cryptography
  ];

  pythonImportsCheck = [ "slip10" ];

  meta = {
    description = "Minimalistic implementation of SLIP109";
    homepage = "https://github.com/trezor/python-slip10";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [
      prusnak
    ];
  };
}
