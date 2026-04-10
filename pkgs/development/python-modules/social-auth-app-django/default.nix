{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  django,
  social-auth-core,
  pytest-django,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "social-auth-app-django";
  version = "5.7.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "python-social-auth";
    repo = "social-app-django";
    tag = version;
    hash = "sha256-iR94psgqFeZEGcS/L/W66H8nCNNKKu+hxOUGC93N8Do=";
  };

  build-system = [ setuptools ];

  dependencies = [
    django
    social-auth-core
  ];

  pythonImportsCheck = [ "social_django" ];

  nativeCheckInputs = [
    pytest-django
    pytestCheckHook
  ];

  preCheck = ''
    export DJANGO_SETTINGS_MODULE=tests.settings
  '';

  meta = {
    broken = lib.versionOlder django.version "5.1";
    description = "Module for social authentication/registration mechanism";
    homepage = "https://github.com/python-social-auth/social-app-django";
    changelog = "https://github.com/python-social-auth/social-app-django/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.bsd3;
    maintainers = [ ];
  };
}
