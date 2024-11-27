{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  setuptools,
  asgiref,
  django,
  strawberry-graphql,
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
  version = "0.47.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "strawberry-graphql";
    repo = "strawberry-django";
    rev = "v${version}";
    hash = "sha256-N7/EJ1AQ2xUJCEX6/xtyH1o/CuDzlvrUtpoDLq+H1WU=";
  };

  build-system = [
    poetry-core
    setuptools
  ];

  dependencies = [
    asgiref
    django
    strawberry-graphql
  ];

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

  optional-dependencies = {
    debug-toolbar = [ django-debug-toolbar ];
    enum = [ django-choices-field ];
  };

  meta = {
    description = "Strawberry GraphQL Django extension";
    homepage = "https://github.com/strawberry-graphql/strawberry-django";
    changelog = "https://github.com/strawberry-graphql/strawberry-django/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ minijackson ];
  };
}
