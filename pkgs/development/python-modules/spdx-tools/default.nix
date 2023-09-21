{ lib
, beartype
, buildPythonPackage
, click
, fetchFromGitHub
, license-expression
, ply
, pytestCheckHook
, pythonOlder
, pyyaml
, rdflib
, semantic-version
, setuptools
, setuptools-scm
, uritools
, xmltodict
}:

buildPythonPackage rec {
  pname = "spdx-tools";
  version = "0.8.1";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "spdx";
    repo = "tools-python";
    rev = "refs/tags/v${version}";
    hash = "sha256-/iBy6i4J/IiJzfNdW6pN3VTE9PVED4ckoe4OBlw8wnI=";
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [
    setuptools
    setuptools-scm
  ];

  propagatedBuildInputs = [
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

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "spdx_tools.spdx"
  ];

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
