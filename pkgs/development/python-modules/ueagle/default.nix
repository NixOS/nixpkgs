{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  requests,
}:

buildPythonPackage (finalAttrs: {
  pname = "ueagle";
  version = "0.0.2";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "jcalbert";
    repo = "uEagle";
    tag = finalAttrs.version;
    hash = "sha256-h4/cUxgBlTLEUDVPEVkPmMdldW8nJB8Gg3VTRVWZvMM=";
  };

  build-system = [ setuptools ];

  dependencies = [ requests ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "uEagle" ];

  meta = {
    description = "Python library Rainforest EAGLE devices";
    homepage = "https://github.com/jcalbert/uEagle";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
