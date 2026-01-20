{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  flit-core,
  webencodings,
  pytest-cov-stub,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "tinycss2";
  version = "1.5.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "kozea";
    repo = "tinycss2";
    tag = "v${version}";
    # for tests
    fetchSubmodules = true;
    hash = "sha256-ZVmdHrqfF5fvBvHLaG2B4m1zek4wfEYArkntWzOqhfM=";
  };

  build-system = [ flit-core ];

  dependencies = [ webencodings ];

  nativeCheckInputs = [
    pytest-cov-stub
    pytestCheckHook
  ];

  meta = {
    description = "Low-level CSS parser for Python";
    homepage = "https://github.com/Kozea/tinycss2";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ onny ];
  };
}
