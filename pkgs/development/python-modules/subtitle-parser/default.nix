{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  chardet,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "subtitle-parser";
  version = "2.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "remram44";
    repo = "subtitle-parser";
    tag = "v${finalAttrs.version}";
    hash = "sha256-uqMedb/WSUaXUHccNTiin3S7V5dDMEaAxla/evIKU1E=";
  };

  build-system = [
    poetry-core
  ];

  # Upstream caps chardet at <6; only chardet.UniversalDetector is used and it
  # is unchanged in 6.x.
  pythonRelaxDeps = [ "chardet" ];

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
    changelog = "https://raw.githubusercontent.com/remram44/subtitle-parser/refs/tags/${finalAttrs.src.tag}/CHANGELOG.md";
    description = "Parser for SRT and WebVTT subtitle files";
    longDescription = "This is a simple Python library for parsing subtitle files in SRT or WebVTT format.";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.imalison ];
  };
})
