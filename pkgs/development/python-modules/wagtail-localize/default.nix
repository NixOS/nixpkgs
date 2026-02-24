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
  version = "1.12.2";
  pyproject = true;

  src = fetchFromGitHub {
    repo = "wagtail-localize";
    owner = "wagtail";
    tag = "v${version}";
    hash = "sha256-DY3owyxJrEPMP4Lfrcyo48gg6be25xSbv87BxW5sPE4=";
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

  checkPhase = ''
    runHook preCheck

    # test_translate_html fails with later Beautifulsoup releases
    rm wagtail_localize/machine_translators/tests/test_dummy_translator.py

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
