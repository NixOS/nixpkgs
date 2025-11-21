{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  regex,
  pytest-asyncio,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "sentence-stream";
  version = "1.2.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "OHF-Voice";
    repo = "sentence-stream";
    tag = "v${version}";
    hash = "sha256-KCKOiY2x+gj02PR0ps2e5Ei6o17tk5ujgCTr3/fkV0Y=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    regex
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "sentence_stream"
  ];

  meta = {
    description = "Small sentence splitter for text streams";
    homepage = "https://github.com/OHF-Voice/sentence-stream";
    changelog = "https://github.com/OHF-Voice/sentence-stream/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ hexa ];
  };
}
