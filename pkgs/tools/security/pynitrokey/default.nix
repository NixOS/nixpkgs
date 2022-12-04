{ python3Packages, lib, nrfutil  }:

with python3Packages;

buildPythonApplication rec {
  pname = "pynitrokey";
  version = "0.4.31";
  format = "flit";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-nqw5wUzQxKCBzYBRhqB6v7WWrF1Ojf8z6Kf1YUA9+wU=";
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
    fido2
    tlv8
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
