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
  version = "0.0.31";
  format = "flit";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "solokeys";
    repo = pname;
    rev = version;
    sha256 = "sha256-OguAHeNpom+zthREzdhejy5HJUIumrtwB0WJAwUNiSA=";
  };

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

  preBuild = ''
    export HOME=$TMPDIR
  '';

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
