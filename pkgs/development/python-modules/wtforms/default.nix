{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  babel,
  hatchling,
  setuptools,

  # dependencies
  markupsafe,

  # optional-dependencies
  email-validator,

  # tests
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "wtforms";
  version = "3.3.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "wtforms";
    repo = "wtforms";
    tag = version;
    hash = "sha256-4UmvzAcEt+dsXLGfAHgG/uN4QEh9uQvMgrjWJn65wIE=";
  };

  nativeBuildInputs = [
    babel
    hatchling
    setuptools
  ];

  propagatedBuildInputs = [ markupsafe ];

  optional-dependencies = {
    email = [ email-validator ];
  };

  nativeCheckInputs = [
    pytestCheckHook
  ]
  ++ lib.concatAttrValues optional-dependencies;

  pythonImportsCheck = [ "wtforms" ];

  meta = {
    description = "Flexible forms validation and rendering library for Python";
    homepage = "https://github.com/wtforms/wtforms";
    changelog = "https://github.com/wtforms/wtforms/blob/${version}/CHANGES.rst";
    license = lib.licenses.bsd3;
  };
}
