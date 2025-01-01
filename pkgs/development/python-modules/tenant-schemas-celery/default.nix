{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  celery,
}:

buildPythonPackage rec {
  pname = "tenant-schemas-celery";
  version = "3.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "maciej-gol";
    repo = "tenant-schemas-celery";
    rev = "refs/tags/${version}";
    hash = "sha256-3ZUXSAOBMtj72sk/VwPV24ysQK+E4l1HdwKa78xrDtg=";
  };

  build-system = [ setuptools ];

  dependencies = [ celery ];

  pythonImportsCheck = [ "tenant_schemas_celery" ];

  meta = {
    description = "Celery application implementation that allows celery tasks to cooperate with multi-tenancy provided by django-tenant-schemas and django-tenants packages";
    homepage = "https://github.com/maciej-gol/tenant-schemas-celery";
    changelog = "https://github.com/maciej-gol/tenant-schemas-celery/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jopejoe1 ];
  };
}
