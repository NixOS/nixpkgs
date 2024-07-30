{ lib
, fetchFromGitHub
, fetchpatch
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "cantoolz";
  version = "3.7.0";

  src = fetchFromGitHub {
    owner = "CANToolz";
    repo = "CANToolz";
    rev = "v${version}";
    sha256 = "sha256-0ROWx1CsKtjxmbCgPYZpvr37VKsEsWCwMehf0/0/cnY=";
  };

  patches = [
    (fetchpatch {
      # Import Iterable from collections.abc
      url = "https://github.com/CANToolz/CANToolz/commit/9e818946716a744b3c7356f248e24ea650791d1f.patch";
      hash = "sha256-BTQ0Io2RF8WpWlLoYfBj8IhL92FRR8ustGClt28/R8c=";
    })
    (fetchpatch {
      # Replace time.clock() which was removed, https://github.com/CANToolz/CANToolz/pull/30
      url = "https://github.com/CANToolz/CANToolz/pull/30/commits/d75574523d3b273c40fb714532c4de27f9e6dd3e.patch";
      sha256 = "0g91hywg5q6f2qk1awgklywigclrbhh6a6mwd0kpbkk1wawiiwbc";
    })
  ];

  propagatedBuildInputs = with python3.pkgs; [
    flask
    pyserial
    mido
    numpy
    bitstring
  ];

  nativeCheckInputs = with python3.pkgs; [
    pytestCheckHook
  ];

  disabledTests = [
    "test_process"
    # Sandbox issue
    "test_server"
  ];

  pythonImportsCheck = [
    "cantoolz"
  ];

  meta = with lib; {
    description = "Black-box CAN network analysis framework";
    mainProgram = "cantoolz";
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
