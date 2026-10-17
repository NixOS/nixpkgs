{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
  setuptools-scm,
  setuptools,
}:

buildPythonPackage rec {
  pname = "textparser";
  version = "0.26.2";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-hZglh2qcOPfDE+4c+ZGlnWtWIyqfZ75tzAp1jYRlT7o=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "textparser" ];

  meta = {
    description = "Module to parse text";
    homepage = "https://github.com/eerimoq/textparser";
    changelog = "https://github.com/cantools/textparser/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ gray-heron ];
  };
}
