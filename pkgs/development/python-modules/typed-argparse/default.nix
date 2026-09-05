{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  typing-extensions,
  pytestCheckHook,
  pytest-cov-stub,
}:
buildPythonPackage {
  pname = "typed-argparse";
  version = "0.3.1-unstable-2026-08-20";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "typed-argparse";
    repo = "typed-argparse";
    rev = "f0e6f8995dfe45a3c9b5484b2806e3194397a1bf";
    hash = "sha256-uXL4NCgH2lnoH+cCJXmpeI/YiqZPiKo5Gx48mYtBz0A=";
  };

  build-system = [ hatchling ];

  dependencies = [ typing-extensions ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-cov-stub
  ];

  pythonImportsCheck = [ "typed_argparse" ];

  meta = {
    description = "Type-safe Python argument parsing";
    homepage = "https://typed-argparse.github.io/typed-argparse/";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.me-and ];
  };
}
