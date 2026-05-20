{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  chardet,
  pytestCheckHook,
}:
let
  version = "2.0.1";
in
buildPythonPackage {
  inherit version;
  pname = "subtitle-parser";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "remram44";
    repo = "subtitle-parser";
    tag = "v${version}";
    hash = "sha256-uqMedb/WSUaXUHccNTiin3S7V5dDMEaAxla/evIKU1E=";
  };

  build-system = [
    poetry-core
  ];

  dependencies = [
    chardet
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  enabledTestPaths = [
    "tests.py"
  ];

  pythonImportsCheck = [ "subtitle_parser" ];

  meta = {
    homepage = "https://github.com/remram44/subtitle-parser";
    changelog = "https://raw.githubusercontent.com/remram44/subtitle-parser/refs/tags/v${version}/CHANGELOG.md";
    description = "Parser for SRT and WebVTT subtitle files";
    longDescription = "This is a simple Python library for parsing subtitle files in SRT or WebVTT format.";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
