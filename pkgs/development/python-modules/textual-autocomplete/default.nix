{
  lib,
  python3,
  fetchFromGitHub,
  poetry-core,
  textual,
  typing-extensions,
  hatchling,
}:
python3.pkgs.buildPythonPackage rec {
  pname = "textual_autocomplete";
  version = "3.0.0a13";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "darrenburns";
    repo = "textual-autocomplete";
    rev = "2cb572bf5b1ea0554b396d0833dfb398cb45dc9b";
    hash = "sha256-jfGYC3xDspwEr+KGApGB05VFuzluDe5S9a/Sjg5HtdI=";
  };

  nativeBuildInputs = [
    poetry-core
    hatchling
  ];

  pythonRelaxDeps = true;

  dependencies = [
    textual
    typing-extensions
  ];

  pythonImportsCheck = [
    "textual"
    "typing_extensions"
  ];

  meta = {
    description = "Python library that provides autocomplete capabilities to textual";
    homepage = "https://pypi.org/project/textual-autocomplete";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jorikvanveen ];
  };
}
