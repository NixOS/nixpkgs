{
  buildPythonPackage,
  fetchFromBitbucket,
  lib,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "zcc-helper";
  version = "3.5.2";
  pyproject = true;

  src = fetchFromBitbucket {
    owner = "mark_hannon";
    repo = "zcc";
    rev = "release_${version}";
    hash = "sha256-6cpLpzzJPoyWaldXZzptV2LY5aYmRtVf0rd1Ye71VG0=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "zcc" ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  disabledTestPaths = [
    # tests require running a server
    "tests/test_controller.py"
    # fixture 'when' not found
    "tests/test_socket.py"
  ];

  meta = {
    description = "ZIMI ZCC helper module";
    homepage = "https://bitbucket.org/mark_hannon/zcc";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
