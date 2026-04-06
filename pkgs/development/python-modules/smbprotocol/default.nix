{
  lib,
  stdenv,
  buildPythonPackage,
  cryptography,
  fetchFromGitHub,
  pyspnego,
  pytest-mock,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "smbprotocol";
  version = "1.16.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "jborean93";
    repo = "smbprotocol";
    tag = "v${version}";
    hash = "sha256-Mxsvfn0O4f+SnofBVxKgmJ/e0iM7c/XjONDEtMVHvkc=";
  };

  propagatedBuildInputs = [
    cryptography
    pyspnego
  ];

  nativeCheckInputs = [
    pytest-mock
    pytestCheckHook
  ];

  disabledTests = lib.optionals stdenv.hostPlatform.isDarwin [
    # https://github.com/jborean93/smbprotocol/issues/119
    "test_copymode_local_to_local_symlink_dont_follow"
    "test_copystat_local_to_local_symlink_dont_follow_fail"

    # fail in sandbox due to networking
    "test_small_recv"
    "test_recv_"
  ];

  pythonImportsCheck = [ "smbprotocol" ];

  meta = {
    description = "Python SMBv2 and v3 Client";
    homepage = "https://github.com/jborean93/smbprotocol";
    changelog = "https://github.com/jborean93/smbprotocol/releases/tag/${src.tag}";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ fab ];
  };
}
