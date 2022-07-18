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
    repo = "solo1-cli";
    rev = version;
    sha256 = "sha256-XVPYr7JwxeZfZ68+vQ7a7MNiAfJ2bvMbM3R1ryVJ+OU=";
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
    # Broken until compatibility with with fido2 >= 1.0 is made
    # see https://github.com/solokeys/solo1-cli/pull/152
    broken = true;
  };
}
