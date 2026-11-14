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
  version = "3.3.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pallets-eco";
    repo = "wtforms";
    tag = version;
    hash = "sha256-vV9gWOq2WrJCltcpYvEYZl1vxyK+CyHJEAwiIY+stXk=";
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
    homepage = "https://github.com/pallets-eco/wtforms";
    changelog = "https://github.com/pallets-eco/wtforms/blob/${version}/CHANGES.rst";
    license = lib.licenses.bsd3;
  };
}
