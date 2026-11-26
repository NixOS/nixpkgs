{
  lib,
  buildPythonPackage,
  distutils,
  fetchPypi,
  jaraco-path,
  pytestCheckHook,
  setuptools,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "pkg-resources-backport";
  version = "1.0.1";
  pyproject = true;

  src = fetchPypi {
    pname = "pkg_resources_backport";
    inherit (finalAttrs) version;
    hash = "sha256-M4wkI+YhPIEPP8LN+yi6q87ikZRDpritDjdirWyuPzw=";
  };

  build-system = [ setuptools ];

  dependencies = [ setuptools ];

  nativeCheckInputs = [
    distutils
    jaraco-path
    pytestCheckHook
    writableTmpDirAsHomeHook
  ];

  pythonImportsCheck = [ "pkg_resources" ];

  disabledTests = [
    "test_get_cache_path"
    "test_interop_pkg_resources_iter_entry_points"
  ];

  meta = {
    description = "Snapshot of last pkg_resources module from setuptools";
    homepage = "https://pypi.org/project/pkg-resources-backport";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
