{ lib
, python3
, fetchFromGitHub
}:

let
  python = python3.override {
    packageOverrides = self: super: {
      yara-python = super.yara-python.overridePythonAttrs (oldAttrs: rec {
        version = "4.2.3";
        src = fetchFromGitHub {
          owner = "VirusTotal";
          repo = "yara-python";
          rev = "v${version}";
          hash = "sha256-spUQuezQMqaG1hboM0/Gs7siCM6x0b40O+sV7qGGBng=";
        };
      });
    };
  };
in
python.pkgs.buildPythonApplication rec {
  pname = "yaralyzer";
  version = "0.9.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "michelcrypt4d4mus";
    repo = "yaralyzer";
    rev = "refs/tags/v${version}";
    hash = "sha256-KGQNonzAZp8c0a3Rjb1WfsEkx5srgRzZfGR3gfNEdzY=";
  };

  pythonRelaxDeps = [
    "python-dotenv"
    "rich"
  ];

  nativeBuildInputs = with python.pkgs; [
    poetry-core
    pythonRelaxDepsHook
  ];

  propagatedBuildInputs = with python.pkgs; [
    chardet
    python-dotenv
    rich
    rich-argparse-plus
    yara-python
  ];

  pythonImportsCheck = [
    "yaralyzer"
  ];

  meta = with lib; {
    description = "Tool to visually inspect and force decode YARA and regex matches";
    homepage = "https://github.com/michelcrypt4d4mus/yaralyzer";
    changelog = "https://github.com/michelcrypt4d4mus/yaralyzer/blob/${version}/CHANGELOG.md";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ fab ];
    mainProgram = "yaralyze";
  };
}
