{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "timeago";
  version = "1.0.16";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "hustcc";
    repo = "timeago";
    rev = version;
    sha256 = "sha256-PqORJKAVrjezU/yP2ky3gb1XsM8obDI3GQzi+mok/OM=";
  };

  nativeCheckInputs = [ pytestCheckHook ];

  enabledTestPaths = [ "test/testcase.py" ];

  pythonImportsCheck = [ "timeago" ];

  meta = {
    description = "Python module to format past datetime output";
    homepage = "https://github.com/hustcc/timeago";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ fab ];
  };
}
