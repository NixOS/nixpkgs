{ lib, buildPythonPackage, fetchFromGitHub
, click, ecdsa, fido2, intelhex, pyserial, pyusb, requests}:

 buildPythonPackage rec {
  pname = "solo-python";
  version = "0.0.15";
  format = "flit";

  src = fetchFromGitHub {
    owner = "solokeys";
    repo = pname;
    rev = version;
    sha256 = "14na9s65hxzx141bdv0j7rx1wi3cv85jzpdivsq1rwp6hdhiazr1";
  };

  # TODO: remove ASAP
  patchPhase = ''
    substituteInPlace pyproject.toml --replace "fido2 == 0.7.0" "fido2 >= 0.7.0"
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

  meta = with lib; {
    description = "Python tool and library for SoloKeys";
    homepage = "https://github.com/solokeys/solo-python";
    maintainers = with maintainers; [ wucke13 ];
    license = with licenses; [ asl20 mit ];
  };
}
