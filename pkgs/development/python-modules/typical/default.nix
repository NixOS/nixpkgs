{ lib, buildPythonPackage, fetchFromGitHub, pytestCheckHook, inflection
, pendulum, fastjsonschema, typing-extensions, orjson, future-typing
, poetry-core, pydantic, sqlalchemy, pandas, mypy }:

buildPythonPackage rec {
  pname = "typical";
  version = "2.7.9";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "seandstewart";
    repo = "typical";
    rev = "v${version}";
    sha256 = "sha256-ITIsSM92zftnvqLiVGFl//IbBb8N3ffkkqohzOx2JO4=";
  };

  patches = [ ./use-poetry-core.patch ];

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [
    inflection
    pendulum
    fastjsonschema
    orjson
    typing-extensions
    future-typing
  ];

  checkInputs = [ pytestCheckHook mypy pydantic sqlalchemy pandas ];

  disabledTests = [
    "test_ujson" # We use orjson
  ];

  disabledTestPaths = [ "benchmark/" ];

  pythonImportsCheck = [ "typic" ];

  meta = with lib; {
    homepage = "https://python-typical.org/";
    description = "Typical: Python's Typing Toolkit.";
    license = licenses.mit;
    maintainers = with maintainers; [ kfollesdal ];
  };
}
