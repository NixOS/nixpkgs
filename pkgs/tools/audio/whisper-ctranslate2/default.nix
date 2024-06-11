{ lib
, python3
, fetchFromGitHub
, nix-update-script
}:
let
  pname = "whisper-ctranslate2";
  version = "0.4.4";
in
python3.pkgs.buildPythonApplication {
  inherit pname version;
  pyproject = true;

  disabled = python3.pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "Softcatala";
    repo = "whisper-ctranslate2";
    rev = version;
    hash = "sha256-iVS1wyPCXlbK1rMFidNbbUohu527NSaCpu1Dve01TvM=";
  };

  build-system = [ python3.pkgs.setuptools ];

  dependencies = with python3.pkgs; [
    ctranslate2
    faster-whisper
    numpy
    pyannote-audio
    sounddevice
    tqdm
  ];

  nativeCheckInputs = with python3.pkgs; [
    nose2
  ];

  checkPhase = ''
    runHook preCheck
    # Note: we are not running the `e2e-tests` because they require downloading models from the internet.
    ${python3.interpreter} -m nose2 -s tests
    runHook postCheck
  '';

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Whisper command line client compatible with original OpenAI client based on CTranslate2";
    homepage = "https://github.com/Softcatala/whisper-ctranslate2";
    changelog = "https://github.com/Softcatala/whisper-ctranslate2/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ happysalada ];
    mainProgram = "whisper-ctranslate2";
  };
}
