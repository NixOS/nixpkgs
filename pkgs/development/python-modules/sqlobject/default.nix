{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools,
  formencode,
  pastedeploy,
  paste,
  pydispatcher,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "sqlobject";
  version = "3.12.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "sqlobject";
    repo = "sqlobject";
    tag = version;
    hash = "sha256-fxENuVTmp/EcDAdVqQWdtqtEW1mI+dfaImgWzGAaWfQ=";
  };

  build-system = [ setuptools ];

  dependencies = [
    formencode
    paste
    pastedeploy
    pydispatcher
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTests = [
    # https://github.com/sqlobject/sqlobject/issues/179
    "test_fail"
  ];

  pythonImportsCheck = [ "sqlobject" ];

  meta = with lib; {
    description = "Object Relational Manager for providing an object interface to your database";
    homepage = "https://www.sqlobject.org/";
    changelog = "https://github.com/sqlobject/sqlobject/blob/${version}/docs/News.rst";
    license = licenses.lgpl21Only;
    maintainers = [ ];
  };
}
