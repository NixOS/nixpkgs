{
  lib,
  buildPythonPackage,
  fetchPypi,
  nix-update-script,
  referencing,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "types-jsonschema";
  version = "4.26.0.20260518";
  pyproject = true;

  src = fetchPypi {
    pname = "types_jsonschema";
    inherit (finalAttrs) version;
    hash = "sha256-4d1T3JemT17M3W+pg5Zm4Ju1AKjrui22/a8XifrqgaY=";
  };

  build-system = [ setuptools ];

  dependencies = [ referencing ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Typing stubs for jsonschema";
    homepage = "https://github.com/python/typeshed";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
})
