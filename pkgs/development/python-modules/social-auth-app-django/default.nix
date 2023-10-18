{ lib
, buildPythonPackage
, fetchFromGitHub
, social-auth-core
, django
, python
, pythonOlder
}:

buildPythonPackage rec {
  pname = "social-auth-app-django";
  version = "5.4.0";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "python-social-auth";
    repo = "social-app-django";
    rev = "refs/tags/${version}";
    hash = "sha256-CZF1DA4UUnmGfdmWlBJ0zJIYx1E03a7Z7Y6WJNFU68M=";
  };

  propagatedBuildInputs = [
    social-auth-core
  ];

  pythonImportsCheck = [
    "social_django"
  ];

  nativeCheckInputs = [
    django
  ];

  checkPhase = ''
    ${python.interpreter} -m django test --settings="tests.settings"
  '';

  meta = with lib; {
    description = "Module for social authentication/registration mechanism";
    homepage = "https://github.com/python-social-auth/social-app-django";
    changelog = "https://github.com/python-social-auth/social-app-django/blob/${version}/CHANGELOG.md";
    license = licenses.bsd3;
    maintainers = with maintainers; [ n0emis ];
  };
}
