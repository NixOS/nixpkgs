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
  version = "3.3.0b3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "wtforms";
    repo = "wtforms";
    tag = version;
    hash = "sha256-h+rzhFPN+N4Jxs9lugvWqNy2eXkXtSCpMW3wp2KgrFk=";
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
