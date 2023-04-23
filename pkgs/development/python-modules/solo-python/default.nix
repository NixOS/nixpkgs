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
  version = "0.1.1";
  format = "flit";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "solokeys";
    repo = pname;
    rev = version;
    hash = "sha256-XVPYr7JwxeZfZ68+vQ7a7MNiAfJ2bvMbM3R1ryVJ+OU=";
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
    description = "Python tool and library for SoloKeys Solo 1";
    homepage = "https://github.com/solokeys/solo1-cli";
    maintainers = with maintainers; [ wucke13 ];
    license = with licenses; [ asl20 mit ];
    # not compatible with fido2 >= 1.0.0
    # https://github.com/solokeys/solo1-cli/issues/157
    broken = versionAtLeast fido2.version "1.0.0";
  };
}
