{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "timeago";
  version = "1.0.16";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "hustcc";
    repo = "timeago";
    tag = finalAttrs.version;
    hash = "sha256-PqORJKAVrjezU/yP2ky3gb1XsM8obDI3GQzi+mok/OM=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  enabledTestPaths = [ "test/testcase.py" ];

  pythonImportsCheck = [ "timeago" ];

  meta = {
    description = "Python module to format past datetime output";
    homepage = "https://github.com/hustcc/timeago";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
