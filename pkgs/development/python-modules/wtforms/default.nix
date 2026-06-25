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

buildPythonPackage (finalAttrs: {
  pname = "wtforms";
  version = "3.3.0b3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "wtforms";
    repo = "wtforms";
    tag = finalAttrs.version;
    hash = "sha256-h+rzhFPN+N4Jxs9lugvWqNy2eXkXtSCpMW3wp2KgrFk=";
  };

  build-system = [
    babel
    hatchling
    setuptools
  ];

  dependencies = [ markupsafe ];

  optional-dependencies = {
    email = [ email-validator ];
  };

  nativeCheckInputs = [
    pytestCheckHook
  ]
  ++ lib.concatAttrValues finalAttrs.passthru.optional-dependencies;

  pythonImportsCheck = [ "wtforms" ];

  meta = {
    description = "Flexible forms validation and rendering library for Python";
    homepage = "https://github.com/wtforms/wtforms";
    changelog = "https://github.com/wtforms/wtforms/blob/${finalAttrs.version}/CHANGES.rst";
    license = lib.licenses.bsd3;
  };
})
