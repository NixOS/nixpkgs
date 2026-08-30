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
    hash = "sha256-OGXbu7jvtLteqnLxvn8+C+AOqLfxJcacvR9f2pJvN6I=";
  };

  nativeCheckInputs = [ unittestCheckHook ];

  meta = {
    description = "Transforms tokens into original source code while preserving whitespace";
    homepage = "https://github.com/myint/untokenize";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ FlorianFranzen ];
  };
}
