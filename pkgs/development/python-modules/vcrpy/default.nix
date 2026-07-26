{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytest-asyncio,
  pytest-httpbin,
  pytestCheckHook,
  pyyaml,
  six,
  urllib3,
  yarl,
  wrapt,
}:

buildPythonPackage rec {
  pname = "vcrpy";
  version = "8.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "kevin1024";
    repo = "vcrpy";
    tag = "v${version}";
    hash = "sha256-WQLWUr1EgOibdAVVASxMzeFi1YikYAjjye/NtCEJ6Kk=";
  };

  build-system = [ setuptools ];

  dependencies = [
    pyyaml
    six
    urllib3
    wrapt
    yarl
  ];

  nativeCheckInputs = [
    pytest-asyncio
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

  meta = {
    description = "Automatically mock your HTTP interactions to simplify and speed up testing";
    homepage = "https://github.com/kevin1024/vcrpy";
    changelog = "https://github.com/kevin1024/vcrpy/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
