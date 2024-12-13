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
  version = "0.1.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "lebrice";
    repo = "SimpleParsing";
    rev = "refs/tags/v${version}";
    hash = "sha256-RDS1sWzaQqXp/0a7dXlUHnd6z+GTIpUN1MnUCTI9LGw=";
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

  disabledTests = [
    # Expected: OrderedDict([('a', 1), ('b', 2), ('c', 5), ('d', 6), ('e', 7)])
    # Got: OrderedDict({'a': 1, 'b': 2, 'c': 5, 'd': 6, 'e': 7})
    # https://github.com/lebrice/SimpleParsing/issues/326
    "simple_parsing.utils.dict_union"
  ];

  meta = {
    description = "Simple, Elegant, Typed Argument Parsing with argparse";
    changelog = "https://github.com/lebrice/SimpleParsing/releases/tag/v${version}";
    homepage = "https://github.com/lebrice/SimpleParsing";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
}
