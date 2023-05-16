<<<<<<< HEAD
{ lib
, python3Packages
, fetchPypi
, nrfutil
, libnitrokey
, nix-update-script
}:
=======
{ python3Packages, lib, nrfutil, libnitrokey }:
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

with python3Packages;

buildPythonApplication rec {
  pname = "pynitrokey";
<<<<<<< HEAD
  version = "0.4.39";
=======
  version = "0.4.36";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "flit";

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-KXYHeWwV9Tw1ZpO/vASHjDnceeb+1K0yIUohb7EcRAI=";
=======
    hash = "sha256-Y+6T1iUp9TVYbAjpXVHozC6WT061r0VYv/ifu8lcN6E=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    certifi
    cffi
    click
<<<<<<< HEAD
    click-aliases
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
    semver
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    spsdk
    tqdm
    urllib3
    tlv8
    typing-extensions
<<<<<<< HEAD
    importlib-metadata
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  nativeBuildInputs = [
    pythonRelaxDepsHook
  ];

  pythonRelaxDeps = [
<<<<<<< HEAD
    "click"
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    "cryptography"
    "protobuf"
    "python-dateutil"
    "spsdk"
    "typing_extensions"
  ];

<<<<<<< HEAD
  # libnitrokey is not propagated to users of the pynitrokey Python package.
=======
  # libnitrokey is not propagated to users of pynitrokey
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  # It is only usable from the wrapped bin/nitropy
  makeWrapperArgs = [
    "--set LIBNK_PATH ${lib.makeLibraryPath [ libnitrokey ]}"
  ];

  # no tests
  doCheck = false;

  pythonImportsCheck = [ "pynitrokey" ];

<<<<<<< HEAD
  passthru.updateScript = nix-update-script { };

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  meta = with lib; {
    description = "Python client for Nitrokey devices";
    homepage = "https://github.com/Nitrokey/pynitrokey";
    license = with licenses; [ asl20 mit ];
    maintainers = with maintainers; [ frogamic ];
    mainProgram = "nitropy";
  };
}
