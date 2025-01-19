{
  lib,
  python3,
  fetchPypi,
  poetry-core,
  textual,
  typing-extensions,
  hatchling,
}:
python3.pkgs.buildPythonPackage rec {
  pname = "textual_autocomplete";
  version = "3.0.0a13";
  pyproject = true;

  # Alpha versions of this packages are only available on Pypi for some reason
  src = fetchPypi {
    inherit pname version;
    hash = "sha256-21pK6VbdfW3s5T9/aV6X8qt1gZ3Za4ocBk7Flms6sRM=";
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
