{
  buildPythonPackage,
  django-pattern-library,
  pytest-django,
  pytestCheckHook,
  wagtail,
  wagtail-factories,
}:

buildPythonPackage {
  pname = "wagtail-factories-tests";
  format = "other";
  inherit (wagtail-factories) src version;

  dontBuild = true;
  dontInstall = true;

  checkInputs = [
    django-pattern-library
    pytestCheckHook
    pytest-django
    wagtail
    wagtail-factories
  ];
}
