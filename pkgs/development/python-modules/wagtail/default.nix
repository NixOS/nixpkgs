<<<<<<< HEAD
{ lib
, anyascii
=======
{ anyascii
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, beautifulsoup4
, buildPythonPackage
, callPackage
, django
, django-filter
, django-modelcluster
, django-taggit
<<<<<<< HEAD
, django-treebeard
=======
, django_treebeard
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, djangorestframework
, draftjs-exporter
, fetchPypi
, html5lib
, l18n
<<<<<<< HEAD
, openpyxl
, permissionedforms
, pillow
, pythonOlder
=======
, lib
, openpyxl
, permissionedforms
, pillow
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, requests
, telepath
, willow
}:

buildPythonPackage rec {
  pname = "wagtail";
<<<<<<< HEAD
  version = "5.0.2";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-3r0h34el2zRF1l/94S7xTjBqJPWtSQFQvtVW8Mjq0rs=";
=======
  version = "4.2.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-s89gs3H//Dc3k6BLZUC4APyDgiWY9LetWAkI+kXQTf8=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  postPatch = ''
    substituteInPlace setup.py \
<<<<<<< HEAD
      --replace "beautifulsoup4>=4.8,<4.12" "beautifulsoup4>=4.8" \
      --replace "Pillow>=4.0.0,<10.0.0" "Pillow>=9.1.0,<11.0.0"
  '';

  propagatedBuildInputs = [
    anyascii
    beautifulsoup4
    django
    django-treebeard
    django-filter
    django-modelcluster
    django-taggit
    djangorestframework
    draftjs-exporter
    html5lib
    l18n
    openpyxl
    permissionedforms
    pillow
    requests
    telepath
    willow
=======
      --replace "beautifulsoup4>=4.8,<4.12" "beautifulsoup4>=4.8"
  '';

  propagatedBuildInputs = [
    django
    django-modelcluster
    django-taggit
    django_treebeard
    djangorestframework
    django-filter
    pillow
    beautifulsoup4
    html5lib
    willow
    requests
    openpyxl
    anyascii
    draftjs-exporter
    permissionedforms
    telepath
    l18n
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  # Tests are in separate derivation because they require a package that depends
  # on wagtail (wagtail-factories)
  doCheck = false;

  passthru.tests.wagtail = callPackage ./tests.nix {};

  meta = with lib; {
    description = "A Django content management system focused on flexibility and user experience";
    homepage = "https://github.com/wagtail/wagtail";
    changelog = "https://github.com/wagtail/wagtail/blob/v${version}/CHANGELOG.txt";
    license = licenses.bsd3;
    maintainers = with maintainers; [ sephi ];
  };
}
