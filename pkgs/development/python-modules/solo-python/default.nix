{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  flit,
  click,
  cryptography,
  ecdsa,
  fido2,
  intelhex,
  pyserial,
  pyusb,
  requests,
}:

buildPythonPackage rec {
  pname = "solo-python";
  version = "0.1.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "solokeys";
    repo = "solo-python";
    tag = version;
    hash = "sha256-XVPYr7JwxeZfZ68+vQ7a7MNiAfJ2bvMbM3R1ryVJ+OU=";
  };

  build-system = [ flit ];

  dependencies = [
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

  meta = {
    description = "Python tool and library for SoloKeys Solo 1";
    homepage = "https://github.com/solokeys/solo1-cli";
    maintainers = with lib.maintainers; [ wucke13 ];
    license = with lib.licenses; [
      asl20
      mit
    ];
    # not compatible with fido2 >= 1.0.0
    # https://github.com/solokeys/solo1-cli/issues/157
    broken = lib.versionAtLeast fido2.version "1.0.0";
  };
}
