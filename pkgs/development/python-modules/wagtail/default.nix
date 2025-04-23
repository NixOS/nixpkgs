{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  anyascii,
  beautifulsoup4,
  django,
  django-filter,
  django-modelcluster,
  django-taggit,
  django-tasks,
  django-treebeard,
  djangorestframework,
  draftjs-exporter,
  laces,
  openpyxl,
  permissionedforms,
  pillow,
  requests,
  telepath,
  willow,

  # tests
  callPackage,
}:

buildPythonPackage rec {
  pname = "wagtail";
  version = "6.4.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "wagtail";
    repo = "wagtail";
    tag = "v${version}";
    hash = "sha256-2qixbJK3f+3SBnsfVEcObFJmuBvE2J9o3LIkILZQRLQ=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    anyascii
    beautifulsoup4
    django
    django-filter
    django-modelcluster
    django-taggit
    django-tasks
    django-treebeard
    djangorestframework
    draftjs-exporter
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

  meta = {
    description = "Django content management system focused on flexibility and user experience";
    mainProgram = "wagtail";
    homepage = "https://github.com/wagtail/wagtail";
    changelog = "https://github.com/wagtail/wagtail/blob/v${version}/CHANGELOG.txt";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ sephi ];
  };
}
