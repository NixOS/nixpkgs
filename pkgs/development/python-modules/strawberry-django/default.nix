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
  strawberry-graphql,

  # optional-dependencies
  django-debug-toolbar,
  django-choices-field,

  # check inputs
  pytestCheckHook,
  django-guardian,
  django-mptt,
  django-polymorphic,
  django-tree-queries,
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
  version = "0.57.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "strawberry-graphql";
    repo = "strawberry-django";
    tag = "v${version}";
    hash = "sha256-AObSY5BkzK+uxKo4NIPN7GgFt/yxFyqxHz3j/wexziI=";
  };

  build-system = [
    poetry-core
    setuptools
  ];

  dependencies = [
    django
    asgiref
    strawberry-graphql
  ];

  optional-dependencies = {
    debug-toolbar = [ django-debug-toolbar ];
    enum = [ django-choices-field ];
  };

  nativeCheckInputs =
    [
      pytestCheckHook

      django-guardian
      django-mptt
      django-polymorphic
      django-tree-queries
      factory-boy
      pillow
      psycopg2
      pytest-cov-stub
      pytest-django
      pytest-mock
      pytest-snapshot
    ]
    ++ optional-dependencies.debug-toolbar
    ++ optional-dependencies.enum;

  pythonImportsCheck = [ "strawberry_django" ];

  meta = {
    description = "Strawberry GraphQL Django extension";
    homepage = "https://github.com/strawberry-graphql/strawberry-django";
    changelog = "https://github.com/strawberry-graphql/strawberry-django/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ minijackson ];
  };
}
