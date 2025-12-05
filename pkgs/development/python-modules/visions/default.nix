{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  attrs,
  multimethod,
  networkx,
  numpy,
  pandas,
  puremagic,

  # optional-dependencies
  shapely,
  imagehash,
  pillow,
  matplotlib,
  pydot,
  pygraphviz,

  # tests
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "visions";
  version = "0.8.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "dylan-profiler";
    repo = "visions";
    tag = "v${version}";
    hash = "sha256-MHseb1XJ0t7jQ45VXKQclYPgddrzmJAC7cde8qqYhNQ=";
  };

  nativeBuildInputs = [ setuptools ];

  dependencies = [
    attrs
    multimethod
    networkx
    numpy
    pandas
    puremagic
  ];

  optional-dependencies = {
    type-geometry = [ shapely ];
    type-image-path = [
      imagehash
      pillow
    ];
    plotting = [
      matplotlib
      pydot
      pygraphviz
    ];
  };

  nativeCheckInputs = [
    pytestCheckHook
  ]
  ++ lib.concatAttrValues optional-dependencies;

  disabledTests = [
    # TypeError: Converting `np.inexact` or `np.floating` to a dtype not allowed
    "test_declarative"
  ];

  disabledTestPaths = [
    # requires running Apache Spark:
    "tests/spark_/typesets/test_spark_standard_set.py"

    # multimethod.DispatchError
    "tests/numpy_/typesets/test_standard_set.py::test_cast"
    "tests/numpy_/typesets/test_standard_set.py::test_conversion"
    "tests/numpy_/typesets/test_standard_set.py::test_inference"
  ];

  pythonImportsCheck = [ "visions" ];

  meta = {
    description = "Type system for data analysis in Python";
    homepage = "https://dylan-profiler.github.io/visions";
    downloadPage = "https://github.com/dylan-profiler/visions";
    changelog = "https://github.com/dylan-profiler/visions/releases/tag/${src.tag}";
    license = lib.licenses.bsdOriginal;
    maintainers = with lib.maintainers; [ bcdarwin ];
  };
}
