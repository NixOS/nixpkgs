{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,

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
  version = "3.2.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "wtforms";
    repo = "wtforms";
    rev = "refs/tags/${version}";
    hash = "sha256-jwjP/wkk8MdNJbPE8MlkrH4DyR304Ju41nN4lMo3jFs=";
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
  ] ++ lib.flatten (lib.attrValues optional-dependencies);

  pythonImportsCheck = [ "wtforms" ];

  meta = with lib; {
    description = "Flexible forms validation and rendering library for Python";
    homepage = "https://github.com/wtforms/wtforms";
    changelog = "https://github.com/wtforms/wtforms/blob/${version}/CHANGES.rst";
    license = licenses.bsd3;
    maintainers = with maintainers; [ bhipple ];
  };
}
