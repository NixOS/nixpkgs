{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  typing-extensions,
  pytestCheckHook,
  pytest-cov-stub,
}:
buildPythonPackage {
  pname = "typed-argparse";
  version = "0.3.1-unstable-2025-05-09";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "typed-argparse";
    repo = "typed-argparse";
    rev = "989887701c5b4e8c835fac60d6124a9efa557e6f";
    hash = "sha256-RgOHIjODBacZdUMCrazZxhQerHtZrNO0BBXPkWPN47o=";
  };

  build-system = [ setuptools ];

  dependencies = [ typing-extensions ];

  pythonImportsCheck = [ "typed_argparse" ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-cov-stub
  ];

  meta = {
    description = "Type-safe Python argument parsing";
    homepage = "https://typed-argparse.github.io/typed-argparse/";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.me-and ];
  };
}
