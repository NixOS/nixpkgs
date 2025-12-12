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
  django-model-utils,
  django-mptt,
  django-polymorphic,
  django-tree-queries,
  factory-boy,
  pillow,
  psycopg2,
  pytest-asyncio,
  pytest-cov-stub,
  pytest-django,
  pytest-mock,
  pytest-snapshot,
}:

buildPythonPackage rec {
  pname = "strawberry-django";
  version = "0.65.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "strawberry-graphql";
    repo = "strawberry-django";
    tag = "v${version}";
    hash = "sha256-cX/eG6qWe/h9U4p1pMhhI+bZ5pLmiwGeYxNthKvdI6o=";
  };

  postPatch = ''
    # django.core.exceptions.ImproperlyConfigured: You're using the staticfiles app without having set the required STATIC_URL setting.
    echo 'STATIC_URL = "static/"' >> tests/django_settings.py
  '';

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

  nativeCheckInputs = [
    pytestCheckHook

    django-guardian
    django-model-utils
    django-mptt
    django-polymorphic
    django-tree-queries
    factory-boy
    pillow
    psycopg2
    pytest-asyncio
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
