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
  version = "5.5.1";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "python-social-auth";
    repo = "social-app-django";
    tag = version;
    hash = "sha256-XS7Uj0h2kb+NfO/9S5DAwZ+6LSjqeNslLwNbbVZmkTw=";
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
    changelog = "https://github.com/python-social-auth/social-app-django/blob/${src.tag}/CHANGELOG.md";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}
