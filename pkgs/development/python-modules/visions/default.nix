{ lib
, buildPythonPackage , fetchFromGitHub
, pythonOlder
, pytestCheckHook
, attrs
, imagehash
, matplotlib
, multimethod
, networkx
, numpy
, pandas
, pillow
, pydot
, pygraphviz
, shapely
}:

buildPythonPackage rec {
  pname = "visions";
  # latest release (Dec 2021) requires barely used 1.8GB `tangled-up-in-unicode` packae
  version = "0.7.5";
  disabled = pythonOlder "3.6";

  format = "setuptools";

  src = fetchFromGitHub {
    owner = "dylan-profiler";
    repo = "visions";
    rev = "refs/tags/v${version}"; #"a0b55bbf95e6efe001195e4b497358d6283966b5";
    hash = "sha256-EmJJbYjajZRRDMwQT7lPHP1cNpoeGx1IjSkx8lF3AFk="; #"sha256-PF2h+05WuNi7lZUF+phvBjjr7yxGkPjnzHKLw0zqkDQ=";
  };

  propagatedBuildInputs = [
    attrs
    imagehash
    multimethod
    networkx
    numpy
    pandas
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ] ++ passthru.optional-dependencies.type-geometry
    ++ passthru.optional-dependencies.type-image-path
    ++ passthru.optional-dependencies.plotting;

  # errors due to use of deprecated Numpy API:
  disabledTests = [ "test_declarative" "test_sequences" ];
  disabledTestPaths = [
    # errors due to use of deprecated Numpy API:
    "tests/numpy_/typesets/test_standard_set.py"
    "tests/pandas_/typesets/test_standard_set_sparse.py"
    # requires running Spark:
    "tests/spark_/typesets/test_spark_standard_set.py"
  ];

  pythonImportsCheck = [
    "visions"
  ];

  passthru.optional-dependencies = {
    type-geometry = [ shapely ];
    type-image-path = [ imagehash pillow ];
    plotting = [ matplotlib pydot pygraphviz ];
  };

  meta = with lib; {
    description = "Type system for data analysis in Python";
    homepage = "https://dylan-profiler.github.io/visions";
    license = licenses.bsdOriginal;
    maintainers = with maintainers; [ bcdarwin ];
  };
}
