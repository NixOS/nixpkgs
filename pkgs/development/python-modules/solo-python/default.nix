{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
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
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "solokeys";
    repo = "solo-python";
    rev = version;
    hash = "sha256-XVPYr7JwxeZfZ68+vQ7a7MNiAfJ2bvMbM3R1ryVJ+OU=";
  };

  nativeBuildInputs = [ flit ];

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

<<<<<<< HEAD
  meta = {
    description = "Python tool and library for SoloKeys Solo 1";
    homepage = "https://github.com/solokeys/solo1-cli";
    maintainers = with lib.maintainers; [ wucke13 ];
    license = with lib.licenses; [
=======
  meta = with lib; {
    description = "Python tool and library for SoloKeys Solo 1";
    homepage = "https://github.com/solokeys/solo1-cli";
    maintainers = with maintainers; [ wucke13 ];
    license = with licenses; [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      asl20
      mit
    ];
    # not compatible with fido2 >= 1.0.0
    # https://github.com/solokeys/solo1-cli/issues/157
<<<<<<< HEAD
    broken = lib.versionAtLeast fido2.version "1.0.0";
=======
    broken = versionAtLeast fido2.version "1.0.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
