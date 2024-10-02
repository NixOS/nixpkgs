{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  textual,
  typing-extensions,
}:

buildPythonPackage {
  pname = "textual-autocomplete";
  version = "3.0.0a9";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "darrenburns";
    repo = "textual-autocomplete";
    rev = "bbacfa91bfd9ff006dab8930a8a3fe4ba46853ab"; # targets `version-two` branch
    hash = "sha256-m2ATH2BNoVCoEzKb5xxe4KPvUlfrwfE+widRIdApkL8=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    textual
    typing-extensions
  ];

  pythonImportsCheck = [ "textual_autocomplete" ];

  doCheck = false; # no tests

  meta = {
    description = "Easily add autocomplete dropdowns to your Textual apps";
    homepage = "https://github.com/darrenburns/textual-autocomplete";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ taha-yassine ];
  };
}
