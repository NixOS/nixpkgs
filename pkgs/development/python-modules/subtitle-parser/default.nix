{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  chardet,
}:

buildPythonPackage rec {
  pname = "subtitle-parser";
  version = "2.0.1";
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

  pythonImportsCheck = [
    "subtitle_parser"
  ];

  # No test available
  doCheck = false;

  meta = {
    changelog = "https://github.com/remram44/subtitle-parser/blob/${src.rev}/CHANGELOG.md";
    description = "Parser for SRT and WebVTT subtitle files";
    homepage = "https://github.com/remram44/subtitle-parser";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ drupol ];
  };
}
