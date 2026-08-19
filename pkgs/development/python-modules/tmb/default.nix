{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  requests,
}:

buildPythonPackage (finalAttrs: {
  pname = "tmb";
  version = "0.1.5";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "alemuro";
    repo = "tmb";
    tag = finalAttrs.version;
    hash = "sha256-XuRhRmeTXAplb14UwISyzaqEIrFeg8/aCdMxUccMUos=";
  };

  build-system = [ setuptools ];

  env.VERSION = finalAttrs.version;

  dependencies = [ requests ];

  pythonImportsCheck = [ "tmb" ];

  # Project has no tests
  doCheck = false;

  meta = {
    description = "Python library that interacts with TMB API";
    homepage = "https://github.com/alemuro/tmb";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
