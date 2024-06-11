{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  voluptuous,

  # tests
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "voluptuous-openapi";
  version = "0.0.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Shulyaka";
    repo = "voluptuous-openapi";
    # TODO: https://github.com/Shulyaka/voluptuous-openapi/commit/155f2dd6d55998c41aaafe0aa8a980f78f9e478b#commitcomment-142845137
    rev = "155f2dd6d55998c41aaafe0aa8a980f78f9e478b";
    hash = "sha256-ciAaWTltPKT9NzfxWoX6gk1gSMszQjVVimfn/0D+mfg=";
  };

  build-system = [ setuptools ];

  dependencies = [ voluptuous ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "voluptuous_openapi" ];

  meta = with lib; {
    description = "Convert voluptuous schemas to OpenAPI Schema object";
    homepage = "https://github.com/Shulyaka/voluptuous-openapi";
    license = licenses.asl20;
    maintainers = with maintainers; [ hexa ];
  };
}
