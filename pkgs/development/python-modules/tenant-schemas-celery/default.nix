{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  celery,
}:

buildPythonPackage rec {
  pname = "tenant-schemas-celery";
  version = "5.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "maciej-gol";
    repo = "tenant-schemas-celery";
    tag = version;
    hash = "sha256-pwulEC7kZpM2f1s0ILi+S7KbxWJjg0O7AQ12/XPCzTQ=";
  };

  build-system = [ setuptools ];

  dependencies = [ celery ];

  pythonImportsCheck = [ "tenant_schemas_celery" ];

  meta = {
    description = "Celery application implementation that allows celery tasks to cooperate with multi-tenancy provided by django-tenant-schemas and django-tenants packages";
    homepage = "https://github.com/maciej-gol/tenant-schemas-celery";
    changelog = "https://github.com/maciej-gol/tenant-schemas-celery/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
