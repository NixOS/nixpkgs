{
  lib,
  beartype,
  buildPythonPackage,
  click,
  fetchFromGitHub,
  license-expression,
  ply,
  pytestCheckHook,
  pyyaml,
  rdflib,
  semantic-version,
  setuptools,
  setuptools-scm,
  uritools,
  xmltodict,
}:

buildPythonPackage (finalAttrs: {
  pname = "spdx-tools";
  version = "0.8.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "spdx";
    repo = "tools-python";
    tag = "v${finalAttrs.version}";
    hash = "sha256-loD+YXRCEYRynOKf7Da43SA7JQVYP1IzJe2f7ssJTtI=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    beartype
    click
    license-expression
    ply
    pyyaml
    rdflib
    semantic-version
    uritools
    xmltodict
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "spdx_tools.spdx" ];

  disabledTestPaths = [
    # Test depends on the currently not packaged pyshacl module
    "tests/spdx3/validation/json_ld/test_shacl_validation.py"
  ];

  disabledTests = [
    # Missing files
    "test_spdx2_convert_to_spdx3"
    "test_json_writer"
  ];

  meta = {
    description = "SPDX parser and tools";
    homepage = "https://github.com/spdx/tools-python";
    changelog = "https://github.com/spdx/tools-python/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
})
