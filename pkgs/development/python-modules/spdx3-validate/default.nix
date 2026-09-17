{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  halo,
  hatchling,
  jsonschema,
  nix-update-script,
  pyshacl,
  pytest-cov-stub,
  pytestCheckHook,
  rdflib,
}:

buildPythonPackage (finalAttrs: {
  pname = "spdx3-validate";
  version = "0.0.7";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "JPEWdev";
    repo = "spdx3-validate";
    tag = "v${finalAttrs.version}";
    hash = "sha256-7BT+WW8fh4UMw0k4aU5TWOgisQRrYPGWS5SDAnQ/2HU=";
  };

  build-system = [ hatchling ];

  dependencies = [
    halo
    jsonschema
    pyshacl
    rdflib
  ];

  nativeCheckInputs = [
    pytest-cov-stub
    pytestCheckHook
  ];

  pythonImportsCheck = [ "spdx3_validate" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Validator for SPDX 3 data files";
    homepage = "https://github.com/JPEWdev/spdx3-validate";
    changelog = "https://github.com/JPEWdev/spdx3-validate/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ znaniye ];
    mainProgram = "spdx3-validate";
  };
})
