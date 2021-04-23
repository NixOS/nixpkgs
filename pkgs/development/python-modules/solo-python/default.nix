{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, click
, cryptography
, ecdsa
, fido2
, intelhex
, pyserial
, pyusb
, requests
}:

 buildPythonPackage rec {
  pname = "solo-python";
  version = "0.0.27";
  format = "flit";
  disabled = pythonOlder "3.6"; # only python>=3.6 is supported

  src = fetchFromGitHub {
    owner = "solokeys";
    repo = pname;
    rev = version;
    sha256 = "sha256-OCiKa6mnqJGoNCC4KqI+hMw22tzhdN63x9/KujNJqcE=";
  };

  # replaced pinned fido, with unrestricted fido version
  patchPhase = ''
    sed -i '/fido2/c\"fido2",' pyproject.toml
  '';

  propagatedBuildInputs = [
    click
    cryptography
    ecdsa
    fido2
    intelhex
    pyserial
    pyusb
    requests
  ];

  # allow for writable directory for darwin
  preBuild = ''
    export HOME=$TMPDIR
  '';

  # repo doesn't contain tests, ensure imports aren't broken
  pythonImportsCheck = [
    "solo"
    "solo.cli"
    "solo.commands"
    "solo.fido2"
    "solo.operations"
  ];

  meta = with lib; {
    description = "Python tool and library for SoloKeys";
    homepage = "https://github.com/solokeys/solo-python";
    maintainers = with maintainers; [ wucke13 ];
    license = with licenses; [ asl20 mit ];
    # solo-python v0.0.27 does not support fido2 >= v0.9
    # https://github.com/solokeys/solo-python/issues/110
    broken = true;
  };
}
