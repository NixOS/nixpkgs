{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  poetry-core,
  poetry-dynamic-versioning,

  # dependencies
  docstring-parser,
  typing-extensions,

  # optional-dependencies
  tomli,
  tomli-w,
  pyyaml,

  # tests
  matplotlib,
  numpy,
  orion,
  pytest-benchmark,
  pytest-regressions,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "simple-parsing";
  version = "0.1.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "lebrice";
    repo = "SimpleParsing";
    tag = "v${version}";
    hash = "sha256-wHk3osr5CNmA/g9ipLy1dgvJoMy1zE/BAGD9ZATE+tc=";
  };

  build-system = [
    poetry-core
    poetry-dynamic-versioning
  ];

  dependencies = [
    docstring-parser
    typing-extensions
  ];

  optional-dependencies = {
    toml = [
      tomli
      tomli-w
    ];
    yaml = [ pyyaml ];
  };

  pythonImportsCheck = [ "simple_parsing" ];

  nativeCheckInputs = [
    matplotlib
    numpy
    orion
    pytest-benchmark
    pytest-regressions
    pytestCheckHook
  ];

  pytestFlags = [ "--benchmark-disable" ];

  disabledTests = [
    # AssertionError
    # https://github.com/lebrice/SimpleParsing/issues/338
    "test_bool_args_in_help"
    "test_desc_from_cls_docstring"
    "test_docstring_builds_upon_bases"
    "test_help_string"
    "test_help_string_displays_default_factory_arguments"
    "test_help_takes_value_from_docstring"
    "test_issue_48"
    "test_running_example_outputs_expected_without_arg"
    "test_subgroup_partial_with_nested_field"
    "test_weird_docstring_with_field_like"
  ];

  meta = {
    description = "Simple, Elegant, Typed Argument Parsing with argparse";
    changelog = "https://github.com/lebrice/SimpleParsing/releases/tag/v${version}";
    homepage = "https://github.com/lebrice/SimpleParsing";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
}
