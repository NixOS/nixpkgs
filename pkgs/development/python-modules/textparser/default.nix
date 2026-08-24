{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools-scm,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "textparser";
  version = "0.26.2";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-hZglh2qcOPfDE+4c+ZGlnWtWIyqfZ75tzAp1jYRlT7o=";
  };

  nativeBuildInputs = [ setuptools-scm ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "textparser" ];

  meta = {
    homepage = "https://github.com/eerimoq/textparser";
    description = "Text parser";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ gray-heron ];
  };
}
