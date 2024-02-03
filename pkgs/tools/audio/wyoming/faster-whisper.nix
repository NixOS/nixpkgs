{ lib
, python3
, fetchPypi
, fetchpatch
}:

python3.pkgs.buildPythonApplication rec {
  pname = "wyoming-faster-whisper";
  version = "1.0.1";
  format = "setuptools";

  src = fetchPypi {
    pname = "wyoming_faster_whisper";
    inherit version;
    hash = "sha256-wo62m8gIP9hXihkd8j2haVvz3TlJv3m5WWthTPFwesk=";
  };

  patches = [
    ./faster-whisper-entrypoint.patch

    # fix model retrieval on python3.11+
    (fetchpatch {
      url = "https://github.com/rhasspy/rhasspy3/commit/ea55a309e55384e6fd8c9f19534622968f8ed95b.patch";
      hash = "sha256-V9WXKE3+34KGubBS23vELTHjqU2RCTk3sX8GTjmH+AA=";
      stripLen = 4;
    })
  ];

  propagatedBuildInputs = with python3.pkgs; [
    ctranslate2
    tokenizers
    wyoming
  ];

  pythonImportsCheck = [
    "wyoming_faster_whisper"
  ];

  # no tests
  doCheck = false;

  meta = with lib; {
    description = "Wyoming Server for Faster Whisper";
    homepage = "https://pypi.org/project/wyoming-faster-whisper/";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
  };
}
