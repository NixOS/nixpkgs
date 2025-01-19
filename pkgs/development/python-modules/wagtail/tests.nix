{
  azure-mgmt-cdn,
  azure-mgmt-frontdoor,
  boto3,
  buildPythonPackage,
  django-pattern-library,
  elasticsearch,
  freezegun,
  jinja2,
  msrest,
  python-dateutil,
  python,
  pytz,
  wagtail,
  wagtail-factories,
}:

buildPythonPackage {
  pname = "wagtail-tests";
  inherit (wagtail) src version;
  format = "other";

  dontBuild = true;
  dontInstall = true;

  checkInputs = [
    azure-mgmt-cdn
    azure-mgmt-frontdoor
    boto3
    django-pattern-library
    elasticsearch
    freezegun
    jinja2
    msrest
    python-dateutil
    pytz
    wagtail
    wagtail-factories
  ];

  checkPhase = ''
    export DJANGO_SETTINGS_MODULE=wagtail.test.settings
    ${python.interpreter} -m django test
  '';
}
