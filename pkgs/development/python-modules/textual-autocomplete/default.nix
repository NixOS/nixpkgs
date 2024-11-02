{
  lib,
  python3,
  fetchPypi,
  poetry-core,
  textual,
  typing-extensions,
}:
python3.pkgs.buildPythonPackage rec {
  pname = "textual_autocomplete";
  version = "3.0.0a12";
  pyproject = true;

  # Alpha versions of this packages are only available on Pypi for some reason
  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-HSyeTSTH9XWryMYSy2q//0cG9qqrm5OVBrldroRUkwk=";
  };

  nativeBuildInputs = [ poetry-core ];

  dependencies = [
    textual
    typing-extensions
  ];

  meta = {
    description = "Python library that provides autocomplete capabilities to textual";
    homepage = "https://pypi.org/project/textual-autocomplete";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jorikvanveen ];
  };
}
