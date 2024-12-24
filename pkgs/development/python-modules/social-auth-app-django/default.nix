{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  social-auth-core,
  django,
  python,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "social-auth-app-django";
  version = "5.4.2";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "python-social-auth";
    repo = "social-app-django";
    rev = "refs/tags/${version}";
    hash = "sha256-W9boogixZ7X6qysfh2YEat+TOBy1VNreGr27y8hno+0=";
  };

  propagatedBuildInputs = [ social-auth-core ];

  pythonImportsCheck = [ "social_django" ];

  nativeCheckInputs = [ django ];

  checkPhase = ''
    ${python.interpreter} -m django test --settings="tests.settings"
  '';

  meta = with lib; {
    description = "Module for social authentication/registration mechanism";
    homepage = "https://github.com/python-social-auth/social-app-django";
    changelog = "https://github.com/python-social-auth/social-app-django/blob/${version}/CHANGELOG.md";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}
