{
  lib,
  buildPythonPackage,

  # build-system
  flit-core,

  # dependencies
  django,
  polib,
  typing-extensions,
  wagtail,
  wagtail-modeladmin,

  # optional-dependencies
  google-cloud-translate,

  # tests
  dj-database-url,
  django-rq,
  fetchFromGitHub,
  freezegun,
  python,
}:

buildPythonPackage rec {
  pname = "wagtail-localize";
  version = "1.13.1";
  pyproject = true;

  src = fetchFromGitHub {
    repo = "wagtail-localize";
    owner = "wagtail";
    tag = "v${version}";
    hash = "sha256-iJwX/N8/aaAjinU1htVasp88fuuZCOomVPgJ1Ymxre4=";
  };

  build-system = [ flit-core ];

  dependencies = [
    django
    polib
    typing-extensions
    wagtail
    wagtail-modeladmin
  ];

  optional-dependencies = {
    google = [ google-cloud-translate ];
  };

  nativeCheckInputs = [
    dj-database-url
    django-rq
    freezegun
    google-cloud-translate
  ];

  # See https://github.com/wagtail/wagtail-localize/issues/922
  patches = [ ./failing-test.patch ];

  checkPhase = ''
    runHook preCheck

    ${python.interpreter} testmanage.py test

    runHook postCheck
  '';

  meta = {
    description = "Translation plugin for Wagtail CMS";
    homepage = "https://github.com/wagtail/wagtail-localize";
    changelog = "https://github.com/wagtail/wagtail-localize/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ sephi ];
  };
}
