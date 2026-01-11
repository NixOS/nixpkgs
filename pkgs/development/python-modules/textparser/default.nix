{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools-scm,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "textparser";
  version = "0.24.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-VvcI51qp0AKtt22CO6bvFm1+zsHj5MpMHKED+BdWgzU=";
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
