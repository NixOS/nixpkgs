{ lib
, attrs
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, pygtrie
, orjson
, python
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "sqltrie";
  version = "0.3.1";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "iterative";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-e/3Tq2H9I0zvqq0+q1c3nbz2UiMNX7JpVpVC9suvYRM=";
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    attrs
    orjson
    pygtrie
  ];

  # nox is not available at the moment
  doCheck = false;

  pythonImportsCheck = [
    "sqltrie"
  ];

  meta = with lib; {
    description = "DVC's data management subsystem";
    homepage = "https://github.com/iterative/sqltrie";
    changelog = "https://github.com/iterative/sqltrie/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
