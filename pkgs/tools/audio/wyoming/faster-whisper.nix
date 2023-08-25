{ lib
, python3
, fetchPypi
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
