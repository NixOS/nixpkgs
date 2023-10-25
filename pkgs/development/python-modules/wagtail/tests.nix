{ azure-mgmt-cdn
, azure-mgmt-frontdoor
, boto3
, buildPythonPackage
, django-pattern-library
, elasticsearch
, freezegun
, jinja2
, python-dateutil
, python
, pytz
, wagtail
, wagtail-factories
}:

buildPythonPackage {
  pname = "wagtail-tests";
  inherit (wagtail) src version;
  format = "other";

  dontBuild = true;
  dontInstall = true;

  checkInputs = [
    wagtail
    wagtail-factories
    jinja2
    freezegun
    elasticsearch
    azure-mgmt-cdn
    python-dateutil
    pytz
    boto3
    django-pattern-library
    azure-mgmt-frontdoor
  ];

  checkPhase = ''
    export DJANGO_SETTINGS_MODULE=wagtail.test.settings
    ${python.interpreter} -m django test
  '';
}
