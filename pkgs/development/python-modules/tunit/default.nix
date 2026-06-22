{
  lib,
  buildPythonPackage,
  fetchFromBitbucket,
  json-handler-registry,
  pytestCheckHook,
  pyyaml,
  setuptools,
  types-pyyaml,
}:

buildPythonPackage (finalAttrs: {
  pname = "tunit";
  version = "1.7.2";
  pyproject = true;

  src = fetchFromBitbucket {
    owner = "massultidev";
    repo = "tunit";
    tag = finalAttrs.version;
    hash = "sha256-S1YEpXQcjQ7gcJPUv4Eo32ypGFkinMjr/x4P/pFMipg=";
  };

  build-system = [ setuptools ];

  optional-dependencies = {
    json = [ json-handler-registry ];
    yaml = [
      pyyaml
      types-pyyaml
    ];
  };

  nativeCheckInputs = [
    pytestCheckHook
  ]
  ++ lib.flatten (builtins.attrValues finalAttrs.passthru.optional-dependencies);

  pythonImportsCheck = [ "tunit" ];

  meta = {
    description = "Module for time unit types";
    homepage = "https://bitbucket.org/massultidev/tunit";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
