{ buildPythonPackage
, dj-database-url
, django
, django-rq
, fetchFromGitHub
, flit-core
, freezegun
, google-cloud-translate
, lib
, polib
, python
, typing-extensions
, wagtail
}:

buildPythonPackage rec {
  pname = "wagtail-localize";
  version = "1.5";
  format = "pyproject";

  src = fetchFromGitHub {
    repo = pname;
    owner = "wagtail";
    rev = "v${version}";
    sha256 = "sha256-aNz4OoUUXWMCahMxuYBxvNWnw7Inxd5svBgwLgoirW8=";
  };

  propagatedBuildInputs = [
    django
    wagtail
    polib
    typing-extensions
  ];

  checkInputs = [
    dj-database-url
    django-rq
    freezegun
    google-cloud-translate
  ];

  nativeBuildInputs = [ flit-core ];

  passthru.optional-dependencies = {
    google = [ google-cloud-translate ];
  };

  checkPhase = ''
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
