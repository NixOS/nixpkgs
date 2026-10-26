{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "textfsm";
  version = "2.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "google";
    repo = "textfsm";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ygVcDdT85mRN+qYfTZqraRVyp2JlLwwujBW1e/pPJNc=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    changelog = "https://github.com/google/textfsm/releases/tag/${finalAttrs.src.tag}";
    description = "Python module for parsing semi-structured text into python tables";
    mainProgram = "textfsm";
    homepage = "https://github.com/google/textfsm";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
})
