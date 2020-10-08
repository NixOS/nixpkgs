{ lib, buildPythonPackage, fetchFromGitHub, pythonOlder
, click, ecdsa, fido2, intelhex, pyserial, pyusb, requests}:

 buildPythonPackage rec {
  pname = "solo-python";
  version = "0.0.26";
  format = "flit";
  disabled = pythonOlder "3.6"; # only python>=3.6 is supported

  src = fetchFromGitHub {
    owner = "solokeys";
    repo = pname;
    rev = version;
    sha256 = "05rwqrhr1as6zqhg63d6wga7l42jm2azbav5w6ih8mx5zbxf61yz";
  };

  # replaced pinned fido, with unrestricted fido version
  patchPhase = ''
    sed -i '/fido2/c\"fido2",' pyproject.toml
  '';

  propagatedBuildInputs = [
    click
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
  };
}
