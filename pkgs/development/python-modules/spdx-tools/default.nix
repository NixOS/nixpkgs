{ lib
<<<<<<< HEAD
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
=======
, buildPythonPackage
, click
, fetchPypi
, pyyaml
, rdflib
, ply
, xmltodict
, pytestCheckHook
, pythonOlder
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  pname = "spdx-tools";
<<<<<<< HEAD
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
=======
  version = "0.7.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-QqKMKBedWOFYF1av9IgQuyJ6b5mNhhMpIZVJdEDcAK8=";
  };

  propagatedBuildInputs = [
    click
    ply
    pyyaml
    rdflib
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    xmltodict
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
<<<<<<< HEAD
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
=======
    "spdx"
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  meta = with lib; {
    description = "SPDX parser and tools";
    homepage = "https://github.com/spdx/tools-python";
    changelog = "https://github.com/spdx/tools-python/blob/v${version}/CHANGELOG.md";
    license = licenses.asl20;
<<<<<<< HEAD
    maintainers = with maintainers; [ fab ];
=======
    maintainers = [ ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
