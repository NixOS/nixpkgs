{ lib
, python3
, fetchPypi
}:

python3.pkgs.buildPythonApplication rec {
  pname = "wyoming-faster-whisper";
  version = "0.0.3";
  format = "setuptools";

  src = fetchPypi {
    pname = "wyoming_faster_whisper";
    inherit version;
    hash = "sha256-uqepa70lprzV3DJK2wrNAAyZkMMJ5S86RKK716zxYU4=";
  };

  patches = [
    ./faster-whisper-entrypoint.patch
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
