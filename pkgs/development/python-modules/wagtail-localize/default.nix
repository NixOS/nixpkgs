<<<<<<< HEAD
{ lib
, buildPythonPackage
=======
{ buildPythonPackage
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, dj-database-url
, django
, django-rq
, fetchFromGitHub
, flit-core
, freezegun
, google-cloud-translate
<<<<<<< HEAD
, polib
, python
, pythonOlder
=======
, lib
, polib
, python
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, typing-extensions
, wagtail
}:

buildPythonPackage rec {
  pname = "wagtail-localize";
<<<<<<< HEAD
  version = "1.5.1";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    repo = pname;
    owner = "wagtail";
    rev = "refs/tags/v${version}";
    hash = "sha256-RjJyx3sr69voJxa3lH8Nq/liZ3eMoTfZ4phykj7neZA=";
  };

  nativeBuildInputs = [
    flit-core
  ];

=======
  version = "1.5";
  format = "pyproject";

  src = fetchFromGitHub {
    repo = pname;
    owner = "wagtail";
    rev = "v${version}";
    sha256 = "sha256-aNz4OoUUXWMCahMxuYBxvNWnw7Inxd5svBgwLgoirW8=";
  };

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  propagatedBuildInputs = [
    django
    wagtail
    polib
    typing-extensions
  ];

<<<<<<< HEAD
  nativeCheckInputs = [
=======
  checkInputs = [
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    dj-database-url
    django-rq
    freezegun
    google-cloud-translate
  ];

<<<<<<< HEAD
  passthru.optional-dependencies = {
    google = [
      google-cloud-translate
    ];
  };

  checkPhase = ''
    # test_translate_html fails with later Beautifulsoup releases
    rm wagtail_localize/machine_translators/tests/test_dummy_translator.py
=======
  nativeBuildInputs = [ flit-core ];

  passthru.optional-dependencies = {
    google = [ google-cloud-translate ];
  };

  checkPhase = ''
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
