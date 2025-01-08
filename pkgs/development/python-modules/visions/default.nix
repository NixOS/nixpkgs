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
  pydot,
  pygraphviz,
  shapely,
}:

buildPythonPackage rec {
  pname = "visions";
  version = "0.7.6";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "dylan-profiler";
    repo = "visions";
    rev = "5fe9dd0c2a5ada0162a005c880bac5296686a5aa"; # no 0.7.6 tag in github
    hash = "sha256-SZzDXm+faAvrfSOT0fwwAf9IH7upNybwKxbjw1CrHj8=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    attrs
    imagehash
    multimethod
    networkx
    numpy
    pandas
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
  ] ++ lib.flatten (builtins.attrValues optional-dependencies);

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
