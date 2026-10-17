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

buildPythonPackage (finalAttrs: {
  pname = "social-auth-app-django";
  version = "6.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "python-social-auth";
    repo = "social-app-django";
    tag = finalAttrs.version;
    hash = "sha256-5aZQcGPX93XITzJCgL+s5Jxep+qqVbYGvzMXDRpZXdY=";
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
    description = "Module for social authentication/registration mechanism";
    homepage = "https://github.com/python-social-auth/social-app-django";
    changelog = "https://github.com/python-social-auth/social-app-django/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.bsd3;
    maintainers = [ ];
  };
})
