{ lib
, bitstring
, buildPythonApplication
, fetchFromGitHub
, fetchpatch
, flask
, mido
, numpy
, pyserial
, pytestCheckHook
, pythonOlder
}:

buildPythonApplication rec {
  pname = "cantoolz";
  version = "3.7.0";
  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "CANToolz";
    repo = "CANToolz";
    rev = "v${version}";
    sha256 = "0xkj7zyx6pz866q61c84mdagpgdyd633v85hk7qxhamca33rc4yi";
  };

  patches = [
    (fetchpatch {
      # Replace time.clock() which was removed, https://github.com/CANToolz/CANToolz/pull/30
      url = "https://github.com/CANToolz/CANToolz/pull/30/commits/d75574523d3b273c40fb714532c4de27f9e6dd3e.patch";
      sha256 = "0g91hywg5q6f2qk1awgklywigclrbhh6a6mwd0kpbkk1wawiiwbc";
    })
  ];

  propagatedBuildInputs = [
    flask
    pyserial
    mido
    numpy
    bitstring
  ];

  checkInputs = [ pytestCheckHook ];
  disabledTests = [ "test_process" ];
  pythonImportsCheck = [ "cantoolz" ];

  meta = with lib; {
    description = "Black-box CAN network analysis framework";
    longDescription = ''
      CANToolz is a framework for analysing CAN networks and devices. It
      provides multiple modules that can be chained using CANToolz's pipe
      system and used by security researchers, automotive/OEM security
      testers in black-box analysis.

      CANToolz can be used for ECU discovery, MitM testing, fuzzing, brute
      forcing, scanning or R&D, testing and validation. More can easily be
      implemented with a new module.
    '';
    homepage = "https://github.com/CANToolz/CANToolz";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
