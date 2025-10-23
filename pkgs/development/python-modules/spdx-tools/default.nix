{
  lib,
  beartype,
  buildPythonPackage,
  click,
  fetchFromGitHub,
  fetchpatch,
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

buildPythonPackage rec {
  pname = "spdx-tools";
  version = "0.8.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "spdx";
    repo = "tools-python";
    tag = "v${version}";
    hash = "sha256-r7+RYGoq3LJYN1jYfwzb1r3fc/kL+CPd4pmGATFq8Pw=";
  };

  patches = [
    # https://github.com/spdx/tools-python/issues/844
    (fetchpatch {
      name = "beartype-0.20-compat.patch";
      url = "https://github.com/spdx/tools-python/pull/841/commits/3b13bd5af36a2b78f5c87fdbadc3f2601d2dcd8d.patch";
      hash = "sha256-8sQNGRss4R1olsw+xGps3NICyimBxKv47TaSrCcnVhA=";
    })
  ];

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

  meta = with lib; {
    description = "SPDX parser and tools";
    homepage = "https://github.com/spdx/tools-python";
    changelog = "https://github.com/spdx/tools-python/blob/v${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
