{ lib
, stdenv
, buildPythonPackage
, cryptography
, fetchFromGitHub
, pyspnego
, pytest-mock
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "smbprotocol";
  version = "1.10.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "jborean93";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-8T091yF/Hu60aaUr6IDZt2cLxz1sXUbMewSqW1Ch0Vo=";
  };

  propagatedBuildInputs = [
    cryptography
    pyspnego
  ];

  nativeCheckInputs = [
    pytest-mock
    pytestCheckHook
  ];

  disabledTests = lib.optionals stdenv.isDarwin [
    # https://github.com/jborean93/smbprotocol/issues/119
    "test_copymode_local_to_local_symlink_dont_follow"
    "test_copystat_local_to_local_symlink_dont_follow_fail"

    # fail in sandbox due to networking
    "test_small_recv"
    "test_recv_"
  ];

  pythonImportsCheck = [
    "smbprotocol"
  ];

  meta = with lib; {
    description = "Python SMBv2 and v3 Client";
    homepage = "https://github.com/jborean93/smbprotocol";
    changelog = "https://github.com/jborean93/smbprotocol/releases/tag/v${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
