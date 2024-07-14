{
  lib,
  buildPythonPackage,
  fetchPypi,
  unittestCheckHook,
}:

buildPythonPackage rec {
  pname = "untokenize";
  version = "0.1.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-OGXbu7jvtLteqnLxvn8+C+AOqLfxJcacvR9f2pJvN6I=";
  };

  nativeCheckInputs = [ unittestCheckHook ];

  meta = with lib; {
    description = "Transforms tokens into original source code while preserving whitespace";
    homepage = "https://github.com/myint/untokenize";
    license = licenses.mit;
    maintainers = with maintainers; [ FlorianFranzen ];
  };
}
