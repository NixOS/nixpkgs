{ python3Packages, lib, nrfutil  }:

with python3Packages;

buildPythonApplication rec {
  pname = "pynitrokey";
  version = "0.4.26";
  format = "flit";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-OuLR6txvoOpOUYpkjA5UkXUIIa1hYCwTmmPuUC3i4zM=";
  };

  propagatedBuildInputs = [
    click
    cryptography
    ecdsa
    fido2
    intelhex
    nrfutil
    pyserial
    pyusb
    requests
    pygments
    python-dateutil
    spsdk
    urllib3
    cffi
    cbor
    nkdfu
  ];

  # spsdk is patched to allow for newer cryptography
  postPatch = ''
    substituteInPlace pyproject.toml \
        --replace "cryptography >=3.4.4,<37" "cryptography"
  '';

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
