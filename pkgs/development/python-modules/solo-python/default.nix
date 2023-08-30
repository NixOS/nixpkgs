{ lib
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
, pythonOlder
, click
, cryptography
, ecdsa
, fido2
, flit-core
, intelhex
, pyserial
, pyusb
, requests
}:

buildPythonPackage rec {
  pname = "solo-python";
  version = "0.1.1";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "solokeys";
    repo = pname;
    rev = version;
    hash = "sha256-XVPYr7JwxeZfZ68+vQ7a7MNiAfJ2bvMbM3R1ryVJ+OU=";
  };

  patches = [
    # https://github.com/solokeys/solo1-cli/pull/166
    (fetchpatch {
      name = "replace-flit-with-flit-core.patch";
      url = "https://github.com/solokeys/solo1-cli/commit/d6abda1fa5b061d8d96c4d4bb6b8da3ba48591e6.patch";
      hash = "sha256-dDphWP7g0C8yE9Pi0ObPq/8m749GV21FZq9cSIT5FkE=";
    })
  ];

  nativeBuildInputs = [
    flit-core
  ];

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
