{ lib
, buildPythonPackage
, fastjsonschema
, fetchFromGitHub
, future-typing
, inflection
, orjson
, pandas
, pendulum
, poetry-core
, pydantic
, pytestCheckHook
, pythonOlder
, sqlalchemy
, ujson
}:

buildPythonPackage rec {
  pname = "typical";
  version = "2.8.1";
  format = "pyproject";

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "seandstewart";
    repo = "typical";
    rev = "refs/tags/v${version}";
    hash = "sha256-2t9Jhdy9NmYBNzdtjjgUnoK2RDEUsAvDkYMcBRzEcmI=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    fastjsonschema
    future-typing
    inflection
    orjson
    pendulum
    ujson
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pydantic
    sqlalchemy
    pandas
  ];

  disabledTests = [
    # ConstraintValueError: Given value <{'key...
    "test_tagged_union_validate"
    # TypeError: 'NoneType' object cannot be interpreted as an integer
    "test_ujson"
  ];

  disabledTestPaths = [
    # We don't care about benchmarks
    "benchmark/"
    # Tests are failing on Hydra
    "tests/mypy/test_mypy.py"
  ];

  pythonImportsCheck = [
    "typic"
  ];

  meta = with lib; {
    description = "Python library for runtime analysis, inference and validation of Python types";
    homepage = "https://python-typical.org/";
    changelog = "https://github.com/seandstewart/typical/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ kfollesdal ];
  };
}
