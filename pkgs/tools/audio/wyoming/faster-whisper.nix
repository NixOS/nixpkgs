{ lib
, python3
, fetchFromGitHub
, fetchpatch
}:

python3.pkgs.buildPythonApplication rec {
  pname = "wyoming-faster-whisper";
  version = "1.0.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "rhasspy";
    repo = "wyoming-faster-whisper";
    rev = "refs/tags/v${version}";
    hash = "sha256-mKnWab3i6lEnCBbO3ucNmWIxaaWwQagzfDhaD1U3qow=";
  };

  patches = [
    # add wyoming-faster-whisper executable
    (fetchpatch {
      url = "https://github.com/rhasspy/wyoming-faster-whisper/commit/a5715197abab34253d2864ed8cf406210834b4ec.patch";
      hash = "sha256-a9gmXMngwXo9ZJDbxl/pPzm6WSy5XeGbz/Xncj7bOog=";
    })

    # fix model retrieval on python3.11+
    (fetchpatch {
      url = "https://github.com/rhasspy/wyoming-faster-whisper/commit/d5229df2c3af536013bc931c1ed7cc239b618208.patch";
      hash = "sha256-CMpOJ1qSPcdtX2h2ecGmQ/haus/gaSH8r/PCFsMChRY=";
    })
  ];

  nativeBuildInputs = with python3.pkgs; [
    setuptools
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
    homepage = "https://github.com/rhasspy/wyoming-faster-whisper";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
  };
}
