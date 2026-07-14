{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonAtLeast,
  unittestCheckHook,
}:

buildPythonPackage rec {
  pname = "untokenize";
  version = "0.1.1";
  format = "setuptools";

  # https://github.com/myint/untokenize/issues/4
  disabled = pythonAtLeast "3.14";

  src = fetchPypi {
    inherit pname version;
    sha256 = "3865dbbbb8efb4bb5eaa72f1be7f3e0be00ea8b7f125c69cbd1f5fda926f37a2";
  };

  nativeCheckInputs = [ unittestCheckHook ];

  meta = {
    description = "Transforms tokens into original source code while preserving whitespace";
    homepage = "https://github.com/myint/untokenize";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ FlorianFranzen ];
  };
}
