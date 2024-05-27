{ lib
, python3
, fetchFromGitHub
, nix-update-script
}:
let
  pname = "whisper-ctranslate2";
  version = "0.4.3";
in
python3.pkgs.buildPythonApplication {
  inherit pname version;
  format = "setuptools";

  disabled = python3.pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "Softcatala";
    repo = "whisper-ctranslate2";
    rev = version;
    hash = "sha256-39kVo4+ZEyjhWbLjw8acW2vJxa3fbQ/tPgnZH3USsYY=";
  };

  propagatedBuildInputs = with python3.pkgs; [
    numpy
    faster-whisper
    ctranslate2
    tqdm
    sounddevice
  ];

  passthru.updateScript = nix-update-script { };

  nativeCheckInputs = with python3.pkgs; [
    nose2
  ];

  checkPhase = ''
    # Note: we are not running the `e2e-tests` because they require downloading models from the internet.
    ${python3.interpreter} -m nose2 -s tests
  '';

  meta = with lib; {
    description = "Whisper command line client compatible with original OpenAI client based on CTranslate2";
    homepage = "https://github.com/Softcatala/whisper-ctranslate2";
    changelog = "https://github.com/Softcatala/whisper-ctranslate2/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ happysalada ];
    mainProgram = "whisper-ctranslate2";
  };
}
