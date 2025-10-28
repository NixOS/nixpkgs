{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  pytestCheckHook,
  setuptools,
  attrs,
  imagehash,
  matplotlib,
  multimethod,
  networkx,
  numpy,
  pandas,
  pillow,
  puremagic,
  pydot,
  pygraphviz,
  shapely,
}:

buildPythonPackage rec {
  pname = "visions";
  version = "0.8.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "dylan-profiler";
    repo = "visions";
    rev = "v${version}";
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
  ++ lib.flatten (builtins.attrValues optional-dependencies);

  disabledTestPaths = [
    # requires running Apache Spark:
    "tests/spark_/typesets/test_spark_standard_set.py"
  ];

  pythonImportsCheck = [
    "visions"
  ];

  meta = with lib; {
    description = "Type system for data analysis in Python";
    homepage = "https://dylan-profiler.github.io/visions";
    license = licenses.bsdOriginal;
    maintainers = with maintainers; [ bcdarwin ];
  };
}
