{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  kvf,
  paradict,
  probed,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "shared";
  version = "0.0.27";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pyrustic";
    repo = "shared";
    tag = finalAttrs.version;
    hash = "sha256-5O/eaVL83gWoh0msparEjcTU+5K532f495OVwkoyJO8=";
  };

  build-system = [ setuptools ];

  dependencies = [
    kvf
    paradict
    probed
  ];

  pythonImportsCheck = [ "shared" ];

  # Module has no tests
  doCheck = false;

  meta = {
    description = "Data exchange and persistence based on human-readable files";
    homepage = "https://github.com/pyrustic/shared";
    changelog = "https://github.com/pyrustic/shared/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
