{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  celery,
}:

buildPythonPackage rec {
  pname = "tenant-schemas-celery";
  version = "4.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "maciej-gol";
    repo = "tenant-schemas-celery";
    tag = version;
    hash = "sha256-rGLrP8rE9SACMDVpNeBU85U/Sb2lNhsgEgHJhAsdKNM=";
  };

  build-system = [ setuptools ];

  dependencies = [ celery ];

  pythonImportsCheck = [ "tenant_schemas_celery" ];

  meta = {
    description = "Celery application implementation that allows celery tasks to cooperate with multi-tenancy provided by django-tenant-schemas and django-tenants packages";
    homepage = "https://github.com/maciej-gol/tenant-schemas-celery";
    changelog = "https://github.com/maciej-gol/tenant-schemas-celery/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jopejoe1 ];
  };
}
