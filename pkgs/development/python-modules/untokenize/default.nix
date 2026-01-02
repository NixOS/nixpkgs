{
  lib,
  buildPythonPackage,
  fetchPypi,
  unittestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "untokenize";
  version = "0.1.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-OGXbu7jvtLteqnLxvn8+C+AOqLfxJcacvR9f2pJvN6I=";
  };

  postPatch = ''
    # Fix AttributeError
      substituteInPlace setup.py \
        --replace-fail 'version=version(),' 'version="${version}"',
  '';

  build-system = [ setuptools ];

  nativeCheckInputs = [ unittestCheckHook ];

  pythonImportsCheck = [ "untokenize" ];

  meta = {
    description = "Transforms tokens into original source code while preserving whitespace";
    homepage = "https://github.com/myint/untokenize";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ FlorianFranzen ];
  };
}
