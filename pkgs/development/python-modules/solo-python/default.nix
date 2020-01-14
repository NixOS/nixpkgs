{ lib, buildPythonPackage, fetchFromGitHub, pythonOlder
, click, ecdsa, fido2, intelhex, pyserial, pyusb, requests}:

 buildPythonPackage rec {
  pname = "solo-python";
  version = "0.0.21";
  format = "flit";
  disabled = pythonOlder "3.6"; # only python>=3.6 is supported

  src = fetchFromGitHub {
    owner = "solokeys";
    repo = pname;
    rev = version;
    sha256 = "07r451dp3ma1mh735b2kjv86a4jkjhmag70cjqf73z7b61dmzl1q";
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
