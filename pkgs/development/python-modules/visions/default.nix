{ lib
, buildPythonPackage
, fetchFromGitHub
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
,
}:
buildPythonPackage rec {
  pname = "visions";
  version = "0.7.6";
  disabled = pythonOlder "3.8";

  format = "setuptools";

  src = fetchFromGitHub {
    owner = "dylan-profiler";
    repo = "visions";
    rev =
      "5fe9dd0c2a5ada0162a005c880bac5296686a5aa"; # no tagged release for 0.7.6
    hash = "sha256-SZzDXm+faAvrfSOT0fwwAf9IH7upNybwKxbjw1CrHj8=";
  };

  propagatedBuildInputs = [ attrs multimethod networkx numpy pandas ];

  nativeCheckInputs = [ pytestCheckHook imagehash ]
    ++ passthru.optional-dependencies.type-geometry
    ++ passthru.optional-dependencies.type-image-path
    ++ passthru.optional-dependencies.plotting;

  disabledTests = [
    "test_create_spark_session"
    "test_import_spark_session"
    "test_spark_backend"
  ];

  pythonImportsCheck = [ "visions" ];

  passthru.optional-dependencies = {
    type-geometry = [ shapely ];
    type-image-path = [ imagehash pillow ];
    plotting = [ matplotlib pydot pygraphviz ];
  };

  meta = with lib; {
    description = "Type system for data analysis in Python";
    homepage = "https://github.com/dylan-profiler/visions";
    license = licenses.bsdOriginal;
    maintainers = with maintainers; [ katanallama ];
  };
}
