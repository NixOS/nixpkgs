{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  poetry-core,
  setuptools,

  # dependencies
  asgiref,
  django,
  django-tree-queries,
  strawberry-graphql,

  # optional-dependencies
  django-debug-toolbar,
  django-choices-field,

  # check inputs
  pytestCheckHook,
  django-guardian,
  django-mptt,
  django-polymorphic,
  factory-boy,
  pillow,
  psycopg2,
  pytest-cov-stub,
  pytest-django,
  pytest-mock,
  pytest-snapshot,
}:

buildPythonPackage rec {
  pname = "strawberry-django";
  version = "0.55.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "strawberry-graphql";
    repo = "strawberry-django";
    tag = "v${version}";
    hash = "sha256-Em6GEYSdVEFkoVa+qI+xN369FOLH9hpEXeMKn9xUCac=";
  };

  build-system = [
    poetry-core
    setuptools
  ];

  dependencies = [
    asgiref
    django
    django-tree-queries
    strawberry-graphql
  ];

  optional-dependencies = {
    debug-toolbar = [ django-debug-toolbar ];
    enum = [ django-choices-field ];
  };


  nativeCheckInputs = [
    pytestCheckHook

    django-guardian
    django-mptt
    django-polymorphic
    factory-boy
    pillow
    psycopg2
    pytest-cov-stub
    pytest-django
    pytest-mock
    pytest-snapshot
  ] ++ optional-dependencies.debug-toolbar ++ optional-dependencies.enum;

  pythonImportsCheck = [ "strawberry_django" ];

  meta = {
    description = "Strawberry GraphQL Django extension";
    homepage = "https://github.com/strawberry-graphql/strawberry-django";
    changelog = "https://github.com/strawberry-graphql/strawberry-django/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ minijackson ];
  };
}
