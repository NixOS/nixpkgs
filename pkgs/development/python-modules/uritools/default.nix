{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "uritools";
  version = "6.1.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tkem";
    repo = "uritools";
    tag = "v${version}";
    hash = "sha256-pZzsdl/q5Piul1Q2cLPkeRmZbW12ACKuI2OYbnG+rMc=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "uritools" ];

  meta = {
    description = "RFC 3986 compliant, Unicode-aware, scheme-agnostic replacement for urlparse";
    homepage = "https://github.com/tkem/uritools/";
    changelog = "https://github.com/tkem/uritools/blob/v${version}/CHANGELOG.rst";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ rvolosatovs ];
  };
}
