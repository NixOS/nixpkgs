{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  jinja2,
  pytestCheckHook,
}:

buildPythonPackage {
  pname = "tiptapy";
  # github repository does not have version tags
  version = "0.20.0-unstable-2024-06-14";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "stckme";
    repo = "tiptapy";
    rev = "f34ed358b1b3448721b791150f4f104347a416bf";
    hash = "sha256-y43/901tznZ9N9A4wH3z8FW0mHzNrA8pC+0d1CxdqJM=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [ jinja2 ];
  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "tiptapy" ];

  meta = {
    description = "Library that generates HTML output from JSON export of tiptap editor";
    homepage = "https://github.com/stckme/tiptapy";
    changelog = "https://github.com/stckme/tiptapy/blob/master/CHANGELOG.rst";
    license = lib.licenses.mit;
    teams = [ lib.teams.apm ];
  };
}
