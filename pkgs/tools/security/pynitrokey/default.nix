{ lib
, python3Packages
, fetchPypi
, nrfutil
, libnitrokey
, nix-update-script
}:

with python3Packages;

buildPythonApplication rec {
  pname = "pynitrokey";
  version = "0.4.39";
  format = "flit";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-KXYHeWwV9Tw1ZpO/vASHjDnceeb+1K0yIUohb7EcRAI=";
  };

  propagatedBuildInputs = [
    certifi
    cffi
    click
    click-aliases
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
    semver
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
    "click"
    "cryptography"
    "protobuf"
    "python-dateutil"
    "spsdk"
    "typing_extensions"
  ];

  # libnitrokey is not propagated to users of the pynitrokey Python package.
  # It is only usable from the wrapped bin/nitropy
  makeWrapperArgs = [
    "--set LIBNK_PATH ${lib.makeLibraryPath [ libnitrokey ]}"
  ];

  # no tests
  doCheck = false;

  pythonImportsCheck = [ "pynitrokey" ];

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Python client for Nitrokey devices";
    homepage = "https://github.com/Nitrokey/pynitrokey";
    license = with licenses; [ asl20 mit ];
    maintainers = with maintainers; [ frogamic ];
    mainProgram = "nitropy";
  };
}
