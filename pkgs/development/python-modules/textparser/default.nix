{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools-scm,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "textparser";
  version = "0.24.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-VvcI51qp0AKtt22CO6bvFm1+zsHj5MpMHKED+BdWgzU=";
  };

  nativeBuildInputs = [ setuptools-scm ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "textparser" ];

  meta = with lib; {
    homepage = "https://github.com/eerimoq/textparser";
    description = "A text parser";
    license = licenses.mit;
    maintainers = with maintainers; [ gray-heron ];
  };
}
