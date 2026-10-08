{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  pythonAtLeast,

  # build-system
  hatchling,
  uv-dynamic-versioning,

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
  pytest-benchmark,
  pytest-regressions,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "simple-parsing";
  version = "0.1.9";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "lebrice";
    repo = "SimpleParsing";
    tag = "v${finalAttrs.version}";
    hash = "sha256-tSQgyxJ0INGQkmqRmzVgKwBd/JXr3OTecdNSfc9Nf94=";
  };

  build-system = [
    hatchling
    uv-dynamic-versioning
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
    pytest-benchmark
    pytest-regressions
    pytestCheckHook
  ];

  pytestFlags = [ "--benchmark-disable" ];

  preCheck =
    # Prevents 'Fatal Python error: Aborted' on darwin during checkPhase
    lib.optionalString stdenv.hostPlatform.isDarwin ''
      export MPLBACKEND="Agg"
    '';

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
  ]
  ++ lib.optionals (pythonAtLeast "3.14") [
    # AssertionError ("usagepython314mpytesthmixed..." != "usagepython314mpytesthmixed")
    "test_each_type_is_used_correctly"
    "test_issue_46"
    "test_issue_46_solution2"

    # TypeError: dest= is required for options like '---------'
    "test_pass_invalid_value_to_add_config_path_arg"
  ];

  meta = {
    description = "Simple, Elegant, Typed Argument Parsing with argparse";
    changelog = "https://github.com/lebrice/SimpleParsing/releases/tag/${finalAttrs.src.tag}";
    homepage = "https://github.com/lebrice/SimpleParsing";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
})
