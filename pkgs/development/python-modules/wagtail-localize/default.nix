{ lib
, buildPythonPackage
, dj-database-url
, django
, django-rq
, fetchFromGitHub
, flit-core
, freezegun
, google-cloud-translate
, polib
, python
, pythonOlder
, typing-extensions
, wagtail
}:

buildPythonPackage rec {
  pname = "wagtail-localize";
  version = "1.7";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    repo = pname;
    owner = "wagtail";
    rev = "refs/tags/v${version}";
    hash = "sha256-Q29Nh/4Z3tYuwoodWKDl5FS+lfl9yDXN7RHn/RReCds=";
  };

  nativeBuildInputs = [
    flit-core
  ];

  propagatedBuildInputs = [
    django
    wagtail
    polib
    typing-extensions
  ];

  nativeCheckInputs = [
    dj-database-url
    django-rq
    freezegun
    google-cloud-translate
  ];

  passthru.optional-dependencies = {
    google = [
      google-cloud-translate
    ];
  };

  checkPhase = ''
    # test_translate_html fails with later Beautifulsoup releases
    rm wagtail_localize/machine_translators/tests/test_dummy_translator.py
    ${python.interpreter} testmanage.py test
  '';

  meta = with lib; {
    description = "Translation plugin for Wagtail CMS";
    homepage = "https://github.com/wagtail/wagtail-localize";
    changelog = "https://github.com/wagtail/wagtail-localize/blob/v${version}/CHANGELOG.md";
    license = licenses.bsd3;
    maintainers = with maintainers; [ sephi ];
  };
}
