{ lib
, buildPythonPackage
, fastjsonschema
, fetchFromGitHub
, future-typing
, inflection
, mypy
, orjson
, pandas
, pendulum
, poetry-core
, pydantic
, pytestCheckHook
, pythonOlder
, sqlalchemy
, typing-extensions
}:

buildPythonPackage rec {
  pname = "typical";
  version = "2.7.9";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "seandstewart";
    repo = "typical";
    rev = "v${version}";
    sha256 = "sha256-ITIsSM92zftnvqLiVGFl//IbBb8N3ffkkqohzOx2JO4=";
  };

  patches = [
    ./use-poetry-core.patch
  ];

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    inflection
    pendulum
    fastjsonschema
    orjson
    future-typing
  ] ++ lib.optionals (pythonOlder "3.10") [
    typing-extensions
  ];

  checkInputs = [
    pytestCheckHook
    mypy
    pydantic
    sqlalchemy
    pandas
  ];

  disabledTests = [
    # We use orjson
    "test_ujson"
    # ConstraintValueError: Given value <{'key...
    "test_tagged_union_validate"
  ];

  disabledTestPaths = [
    "benchmark/"
  ];

  pythonImportsCheck = [
    "typic"
  ];

  meta = with lib; {
    description = "Python library for runtime analysis, inference and validation of Python types";
    homepage = "https://python-typical.org/";
    license = licenses.mit;
    maintainers = with maintainers; [ kfollesdal ];
  };
}
