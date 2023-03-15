{ lib
, buildPythonPackage
, fastjsonschema
, fetchFromGitHub
, fetchpatch
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
, ujson
}:

buildPythonPackage rec {
  pname = "typical";
  version = "2.8.0";
  format = "pyproject";

  # Support for typing-extensions >= 4.0.0 on Python < 3.10 is missing
  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "seandstewart";
    repo = "typical";
    rev = "v${version}";
    hash = "sha256-DRjQmoZzWw5vpwIx70wQg6EO/aHqyX7RWpWZ9uOxSTg=";
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
    mypy
    pydantic
    sqlalchemy
    pandas
  ];

  patches = [
    # Switch to poetry-core, https://github.com/seandstewart/typical/pull/193
    (fetchpatch {
      name = "switch-to-poetry-core.patch";
      url = "https://github.com/seandstewart/typical/commit/66b3c34f8969b7fb1f684f0603e514405bab0dd7.patch";
      sha256 = "sha256-c7qJOtHmJRnVEGl+OADB3HpjvMK8aYDD9+0gplOn9pQ=";
    })
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
    license = licenses.mit;
    maintainers = with maintainers; [ kfollesdal ];
  };
}
