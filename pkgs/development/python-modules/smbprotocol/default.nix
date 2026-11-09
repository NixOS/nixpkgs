{
  lib,
  stdenv,
  buildPythonPackage,
  cryptography,
  fetchFromGitHub,
  pyspnego,
  pytest-mock,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "smbprotocol";
  version = "1.17.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jborean93";
    repo = "smbprotocol";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Mqv4vngO2tPXThsB/Z4RW7v09sfqZdqRKDW70GqjHH4=";
  };

  build-system = [ setuptools ];

  dependencies = [
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
    changelog = "https://github.com/jborean93/smbprotocol/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
