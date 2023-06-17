{ lib, python3Packages, fetchPypi, nrfutil, libnitrokey }:

with python3Packages;

buildPythonApplication rec {
  pname = "pynitrokey";
  version = "0.4.37";
  format = "flit";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-KoZym1b+E0P3kRt0PTm9wCX4nO31isDIwEq38xMgDDU=";
  };

  propagatedBuildInputs = [
    certifi
    cffi
    click
    cryptography
    ecdsa
    frozendict
    fido2
    intelhex
    nkdfu
    nrfutil
    python-dateutil
    pyusb
    requests
    spsdk
    tqdm
    urllib3
    tlv8
    typing-extensions
  ];

  nativeBuildInputs = [
    pythonRelaxDepsHook
  ];

  pythonRelaxDeps = [
    "cryptography"
    "protobuf"
    "python-dateutil"
    "spsdk"
    "typing_extensions"
  ];

  # libnitrokey is not propagated to users of pynitrokey
  # It is only usable from the wrapped bin/nitropy
  makeWrapperArgs = [
    "--set LIBNK_PATH ${lib.makeLibraryPath [ libnitrokey ]}"
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
