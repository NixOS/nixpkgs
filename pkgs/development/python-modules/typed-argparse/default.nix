{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonAtLeast,
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

  nativeCheckInputs = [
    pytestCheckHook
    pytest-cov-stub
  ];

  # The test suite checks for exact output in a way that seems fragile to
  # cosmetic changes in Python's argparse output, and means some tests fail on
  # more recent releases.  Disable the affected tests while we're waiting for
  # upstream fixes.
  #
  # https://github.com/typed-argparse/typed-argparse/pull/82
  # https://github.com/typed-argparse/typed-argparse/issues/84
  disabledTests =
    lib.optionals (pythonAtLeast "3.14") [
      "test_nargs_with_choices__literal_illegal_default"
      "test_nargs_with_choices__enum_illegal_default"
      "test_bindings_check"
      "test_check_reserved_names"
    ]
    ++ lib.optionals (pythonAtLeast "3.13") [
      "test_dynamic_choices"
      "test_literal__basics"
      "test_enum__basics[False]"
      "test_enum__basics[True]"
      "test_subparsers_common_args__subparser_after_positional"
    ];

  pythonImportsCheck = [ "typed_argparse" ];

  meta = {
    description = "Type-safe Python argument parsing";
    homepage = "https://typed-argparse.github.io/typed-argparse/";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.me-and ];
  };
}
