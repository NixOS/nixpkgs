{ lib
, fetchFromGitHub
, nix-update-script
, python3
}:
let
  pname = "whisper-ctranslate2";
  version = "0.2.7";
in
python3.pkgs.buildPythonApplication {
  inherit pname version;
  format = "setuptools";

  disabled = python3.pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "Softcatala";
    repo = pname;
    rev = version;
    hash = "sha256-dUmQNKgH+SIlLhUEiaEGXUHZQDr3fidsAU2vATJiXBU=";
  };

  propagatedBuildInputs = with python3.pkgs; [
    numpy
    faster-whisper
    ctranslate2
    tqdm
    sounddevice
  ];

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Whisper command line client compatible with original OpenAI client based on CTranslate2";
    homepage = "https://github.com/Softcatala/whisper-ctranslate2";
    changelog = "https://github.com/Softcatala/whisper-ctranslate2/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ happysalada ];
  };
}
