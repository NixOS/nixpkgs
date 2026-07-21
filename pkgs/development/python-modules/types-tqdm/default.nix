{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  types-requests,
}:

buildPythonPackage (finalAttrs: {
  pname = "types-tqdm";
  version = "4.68.0.20260608";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchPypi {
    pname = "types_tqdm";
    inherit (finalAttrs) version;
    hash = "sha256-4d/d+HcPvDDsr5WuV8KGOXgxI1BkMI99/CsdZoSnYQc=";
  };

  build-system = [ setuptools ];

  dependencies = [ types-requests ];

  # This package does not have tests.
  doCheck = false;

  meta = {
    description = "Typing stubs for tqdm";
    homepage = "https://pypi.org/project/types-tqdm/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
})
