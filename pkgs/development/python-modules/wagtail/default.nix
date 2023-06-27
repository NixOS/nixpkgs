{ lib
, anyascii
, beautifulsoup4
, buildPythonPackage
, callPackage
, django
, django-filter
, django-modelcluster
, django-taggit
, django_treebeard
, djangorestframework
, draftjs-exporter
, fetchPypi
, html5lib
, l18n
, openpyxl
, permissionedforms
, pillow
, pythonOlder
, requests
, telepath
, willow
}:

buildPythonPackage rec {
  pname = "wagtail";
  version = "4.2.2";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-s89gs3H//Dc3k6BLZUC4APyDgiWY9LetWAkI+kXQTf8=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "beautifulsoup4>=4.8,<4.12" "beautifulsoup4>=4.8"
  '';

  propagatedBuildInputs = [
    anyascii
    beautifulsoup4
    django
    django_treebeard
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
