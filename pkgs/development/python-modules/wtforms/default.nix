{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder

# build-system
, babel
, hatchling
, setuptools

# dependencies
, markupsafe

# optional-dependencies
, email-validator

# tests
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "wtforms";
  version = "3.1.2";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "wtforms";
    repo = "wtforms";
    rev = "refs/tags/${version}";
    hash = "sha256-L6DmB7iVpJR775oRxuEkCKWlUJnmw8VPZTr2dZbqeEc=";
  };

  nativeBuildInputs = [
    babel
    hatchling
    setuptools
  ];

  propagatedBuildInputs = [
    markupsafe
  ];

  passthru.optional-dependencies = {
    email = [
      email-validator
    ];
  };

  nativeCheckInputs = [
    pytestCheckHook
  ] ++ lib.flatten (lib.attrValues passthru.optional-dependencies);

  pythonImportsCheck = [
    "wtforms"
  ];

  meta = with lib; {
    description = "A flexible forms validation and rendering library for Python";
    homepage = "https://github.com/wtforms/wtforms";
    changelog = "https://github.com/wtforms/wtforms/blob/${version}/CHANGES.rst";
    license = licenses.bsd3;
    maintainers = with maintainers; [ bhipple ];
  };

}
