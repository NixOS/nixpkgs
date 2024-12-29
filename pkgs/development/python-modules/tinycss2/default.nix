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
  version = "1.4.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "kozea";
    repo = "tinycss2";
    rev = "refs/tags/${version}";
    # for tests
    fetchSubmodules = true;
    hash = "sha256-Exjxdm0VnnjHUKjquXsC/zDmwA7bELHdX1f55IGBjYk=";
  };

  build-system = [ flit-core ];

  dependencies = [ webencodings ];

  nativeCheckInputs = [
    pytest-cov-stub
    pytestCheckHook
  ];

  meta = with lib; {
    description = "Low-level CSS parser for Python";
    homepage = "https://github.com/Kozea/tinycss2";
    license = licenses.bsd3;
    maintainers = with maintainers; [ onny ];
  };
}
