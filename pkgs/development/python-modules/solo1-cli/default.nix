{ lib
, buildPythonPackage
, fetchFromGitHub
, fetchPypi
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

let
  # TODO remove this once https://github.com/solokeys/solo1-cli/issues/157 is addressed
  fido2-old = fido2.overrideAttrs (x: rec {
    version = "0.9.3";
    src = fetchPypi {
      inherit (x) pname;
      inherit version;
      sha256 = "sha256-tF6JphCc/Lfxu1E3dqotZAjpXEgi+DolORi5RAg0Zuw=";
    };
  });
in
buildPythonPackage rec {
  pname = "solo1-cli";
  version = "0.1.1";
  format = "flit";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "solokeys";
    repo = pname;
    rev = version;
    sha256 = "sha256-XVPYr7JwxeZfZ68+vQ7a7MNiAfJ2bvMbM3R1ryVJ+OU=";
  };

  propagatedBuildInputs = [
    click
    cryptography
    ecdsa
    fido2-old
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
