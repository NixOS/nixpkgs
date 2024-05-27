{
  lib,
  buildPythonPackage,
  pythonOlder,
  pythonAtLeast,
  fetchFromGitHub,
  setuptools,
  colorama,
  pytz,
  requests,
  six,
  libunwind,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "vmprof";
  version = "0.4.17";
  pyproject = true;

  disabled = pythonOlder "3.6" || pythonAtLeast "3.12";

  src = fetchFromGitHub {
    owner = "vmprof";
    repo = "vmprof-python";
    rev = "refs/tags/${version}";
    hash = "sha256-7k6mtEdPmp1eNzB4l/k/ExSYtRJVmRxcx50ql8zR36k=";
  };

  build-system = [ setuptools ];

  dependencies = [
    colorama
    requests
    six
    pytz
  ];

  buildInputs = [ libunwind ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTests = [
    "test_gzip_call"
    "test_is_enabled"
    "test_get_profile_path"
    "test_get_runtime"
  ];

  pythonImportsCheck = [ "vmprof" ];

  meta = with lib; {
    description = "A vmprof client";
    mainProgram = "vmprofshow";
    license = licenses.mit;
    homepage = "https://vmprof.readthedocs.org/";
  };
}
