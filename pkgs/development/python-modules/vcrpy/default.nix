{
  lib,
  buildPythonPackage,
  fetchPypi,
  fetchpatch,
  pytest-httpbin,
  pytestCheckHook,
  pythonOlder,
  pyyaml,
  six,
  yarl,
  wrapt,
}:

buildPythonPackage rec {
  pname = "vcrpy";
  version = "7.0.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-F2ORrQQl7d4WgMWyBzjqPcf7lCUgpI0pk0SAUJhrOlA=";
  };

  patches = [
    (fetchpatch {
      # python 3.14 compat
      url = "https://github.com/kevin1024/vcrpy/commit/558c7fc625e66775da11ee406001f300e6188fb2.patch";
      hash = "sha256-keShvz8zwqkenEtQ+NAnGKwSLYGbtXfpfMP8Zje2p+o=";
    })
  ];

  propagatedBuildInputs = [
    pyyaml
    six
    yarl
    wrapt
  ];

  nativeCheckInputs = [
    pytest-httpbin
    pytestCheckHook
  ];

  disabledTestPaths = [ "tests/integration" ];

  disabledTests = [
    "TestVCRConnection"
    # https://github.com/kevin1024/vcrpy/issues/645
    "test_get_vcr_with_matcher"
    "test_testcase_playback"
  ];

  pythonImportsCheck = [ "vcr" ];

  meta = with lib; {
    description = "Automatically mock your HTTP interactions to simplify and speed up testing";
    homepage = "https://github.com/kevin1024/vcrpy";
    changelog = "https://github.com/kevin1024/vcrpy/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = [ ];
  };
}
