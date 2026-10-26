{
  lib,
  stdenv,
  fetchFromGitHub,
  buildPythonPackage,
  pytestCheckHook,
  setuptools,
  regex,
}:

buildPythonPackage (finalAttrs: {
  pname = "somajo";
  version = "2.5.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tsproisl";
    repo = "SoMaJo";
    tag = "v${finalAttrs.version}";
    hash = "sha256-2ddFfwTZGAWBnZprkD5qTBezAOl9DaraNwwWWVGQz8I=";
  };

  build-system = [ setuptools ];

  dependencies = [ regex ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "somajo" ];

  meta = {
    description = "Tokenizer and sentence splitter for German and English web texts";
    homepage = "https://github.com/tsproisl/SoMaJo";
    changelog = "https://github.com/tsproisl/SoMaJo/blob/v${finalAttrs.version}/CHANGES.txt";
    license = lib.licenses.gpl3Plus;
    maintainers = [ ];
    mainProgram = "somajo-tokenizer";
  };
})
