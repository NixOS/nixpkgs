{ python3Packages, lib }:

with python3Packages;

buildPythonApplication rec {
  pname = "pynitrokey";
  version = "0.4.9";
  format = "flit";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-mhH6mVgLRX87PSGTFkj1TE75jU1lwcaRZWbC67T+vWo=";
  };

  propagatedBuildInputs = [
    click
    cryptography
    ecdsa
    fido2
    intelhex
    pyserial
    pyusb
    requests
    pygments
    python-dateutil
    urllib3
    cffi
    cbor
    nkdfu
  ];

  # no tests
  doCheck = false;

  pythonImportsCheck = [ "pynitrokey" ];

  meta = with lib; {
    description = "Python client for Nitrokey devices";
    homepage = "https://github.com/Nitrokey/pynitrokey";
    license = with licenses; [ asl20 mit ];
    maintainers = with maintainers; [ frogamic ];
    mainProgram = "nitropy";
  };
}
