{
  lib,
  blockdiag,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "seqdiag";
  version = "3.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "blockdiag";
    repo = "seqdiag";
    tag = finalAttrs.version;
    hash = "sha256-Dh9JMx50Nexi0q39rYr9MpkKmQRAfT7lzsNOXoTuphg=";
  };

  build-system = [ setuptools ];

  dependencies = [ blockdiag ];

  patches = [ ./fix_test_generate.patch ];

  nativeCheckInputs = [ pytestCheckHook ];
  enabledTestPaths = [ "src/seqdiag/tests/" ];

  pythonImportsCheck = [ "seqdiag" ];

  meta = {
    description = "Generate sequence-diagram image from spec-text file (similar to Graphviz)";
    homepage = "http://blockdiag.com/";
    changelog = "https://github.com/blockdiag/seqdiag/blob/${finalAttrs.version}/CHANGES.rst";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ bjornfor ];
    mainProgram = "seqdiag";
    platforms = lib.platforms.unix;
  };
})
