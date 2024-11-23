{
  lib,
  anyascii,
  beautifulsoup4,
  buildPythonPackage,
  callPackage,
  django,
  django-filter,
  django-modelcluster,
  django-taggit,
  django-treebeard,
  djangorestframework,
  draftjs-exporter,
  fetchPypi,
  html5lib,
  l18n,
  laces,
  openpyxl,
  permissionedforms,
  pillow,
  pythonOlder,
  requests,
  telepath,
  willow,
}:

buildPythonPackage rec {
  pname = "wagtail";
  version = "6.3.1";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-k4dsx6O/z/9MA5OUlWLL8knyRMTKZT1Yoturc39FVxU=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "django-filter>=23.3,<24" "django-filter>=23.3,<24.3"
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
    laces
    openpyxl
    permissionedforms
    pillow
    requests
    telepath
    willow
  ] ++ willow.optional-dependencies.heif;

  # Tests are in separate derivation because they require a package that depends
  # on wagtail (wagtail-factories)
  doCheck = false;

  passthru.tests.wagtail = callPackage ./tests.nix { };

  pythonImportsCheck = [ "wagtail" ];

  meta = with lib; {
    description = "Django content management system focused on flexibility and user experience";
    mainProgram = "wagtail";
    homepage = "https://github.com/wagtail/wagtail";
    changelog = "https://github.com/wagtail/wagtail/blob/v${version}/CHANGELOG.txt";
    license = licenses.bsd3;
    maintainers = with maintainers; [ sephi ];
  };
}
