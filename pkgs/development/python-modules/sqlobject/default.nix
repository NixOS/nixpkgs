{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools,
  formencode,
  pydispatcher,
}:

buildPythonPackage rec {
  pname = "sqlobject";
  version = "3.14.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "sqlobject";
    repo = "sqlobject";
    tag = version;
    hash = "sha256-M4VnQdNmAunJYXY+oyTEcj3jABPNcMwQvyy7uwX6nOU=";
  };

  build-system = [ setuptools ];

  dependencies = [
    formencode
    pydispatcher
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTests = [
    # https://github.com/sqlobject/sqlobject/issues/179
    "test_fail"
  ];

  pythonImportsCheck = [ "sqlobject" ];

  meta = {
    description = "Object Relational Manager for providing an object interface to your database";
    homepage = "https://www.sqlobject.org/";
    changelog = "https://github.com/sqlobject/sqlobject/blob/${src.tag}/docs/News.rst";
    license = lib.licenses.lgpl21Only;
    maintainers = [ ];
  };
}
