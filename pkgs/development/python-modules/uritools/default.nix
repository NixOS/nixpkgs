{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  setuptools-scm,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "uritools";
  version = "6.1.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tkem";
    repo = "uritools";
    tag = "v${finalAttrs.version}";
    hash = "sha256-pZzsdl/q5Piul1Q2cLPkeRmZbW12ACKuI2OYbnG+rMc=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  # Infinite recursion
  doCheck = false;

  pythonImportsCheck = [ "uritools" ];

  meta = {
    description = "RFC 3986 compliant, Unicode-aware, scheme-agnostic replacement for urlparse";
    homepage = "https://github.com/tkem/uritools/";
    changelog = "https://github.com/tkem/uritools/blob/${finalAttrs.src.tag}/CHANGELOG.rst";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ rvolosatovs ];
  };
})
