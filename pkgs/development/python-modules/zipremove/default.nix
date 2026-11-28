{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "zipremove";
  version = "0.10.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "danny0838";
    repo = "zipremove";
    tag = "v${finalAttrs.version}";
    hash = "sha256-tcnE+RoU64aCoJHc1GoY7q3SDr8CTfYHbsNjej+A5d4=";
  };

  build-system = [ setuptools ];

  # The tests import helpers from CPython's test suite that are not packaged.
  doCheck = false;

  pythonImportsCheck = [ "zipremove" ];

  meta = {
    changelog = "https://github.com/danny0838/zipremove/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    description = "Extended `zipfile.ZipFile` with remove-related capabilities";
    homepage = "https://github.com/danny0838/zipremove";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.mdaniels5757 ];
  };
})
