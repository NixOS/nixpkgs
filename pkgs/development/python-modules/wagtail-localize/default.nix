{
  lib,
  buildPythonPackage,
  dj-database-url,
  django,
  django-rq,
  fetchFromGitHub,
  flit-core,
  freezegun,
  google-cloud-translate,
  polib,
  python,
  pythonOlder,
  typing-extensions,
  wagtail,
  wagtail-modeladmin,
}:

buildPythonPackage rec {
  pname = "wagtail-localize";
  version = "1.11.3";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    repo = "wagtail-localize";
    owner = "wagtail";
    tag = "v${version}";
    hash = "sha256-uTZqpitexB5e2/W9HtNo0j4gOW9vDS2BsaVq16BUFM4=";
  };

  build-system = [ flit-core ];

  dependencies = [
    django
    wagtail
    polib
    typing-extensions
    wagtail-modeladmin
  ];

  nativeCheckInputs = [
    dj-database-url
    django-rq
    freezegun
    google-cloud-translate
  ];

  optional-dependencies = {
    google = [ google-cloud-translate ];
  };

  checkPhase = ''
    # test_translate_html fails with later Beautifulsoup releases
    rm wagtail_localize/machine_translators/tests/test_dummy_translator.py
    ${python.interpreter} testmanage.py test
  '';

  meta = with lib; {
    description = "Translation plugin for Wagtail CMS";
    homepage = "https://github.com/wagtail/wagtail-localize";
    changelog = "https://github.com/wagtail/wagtail-localize/blob/${src.tag}/CHANGELOG.md";
    license = licenses.bsd3;
    maintainers = with maintainers; [ sephi ];
  };
}
