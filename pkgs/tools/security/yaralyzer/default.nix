{ lib
, python3
, fetchFromGitHub
}:

python3.pkgs.buildPythonApplication rec {
  pname = "yaralyzer";
  version = "0.9.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "michelcrypt4d4mus";
    repo = "yaralyzer";
    rev = "refs/tags/v${version}";
    hash = "sha256-QsMO/fnHy4puuToUHSS05fWnXHdAVnWFFBVq3cb0Zj4=";
  };

  pythonRelaxDeps = [
    "python-dotenv"
    "rich"
  ];

  nativeBuildInputs = with python3.pkgs; [
    poetry-core
    pythonRelaxDepsHook
  ];

  propagatedBuildInputs = with python3.pkgs; [
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
  };
}
