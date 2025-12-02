{
  lib,
  buildPythonPackage,
  fetchPypi,

  # build-system
  setuptools,

  # dependencies
  anyascii,
  beautifulsoup4,
  django,
  django-filter,
  django-modelcluster,
  django-modelsearch,
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
  version = "7.2";
  pyproject = true;

  # The GitHub source requires some assets to be compiled, which in turn
  # requires fixing the upstream package lock. We need to use the PyPI release
  # until https://github.com/wagtail/wagtail/pull/13136 gets merged.
  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ijnfkIvWSrAp4IvxkfR19UzJFPhKpB6a55tBv0HVXsM=";
  };

  build-system = [
    setuptools
  ];

  pythonRelaxDeps = [ "django-tasks" ];

  dependencies = [
    anyascii
    beautifulsoup4
    django
    django-filter
    django-modelcluster
    django-modelsearch
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
  ]
  ++ willow.optional-dependencies.heif;

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
