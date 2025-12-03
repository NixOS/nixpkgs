{
  lib,
  stdenv,
  asyncssh,
  bcrypt,
  buildPythonPackage,
  fetchFromGitHub,
  fsspec,
  importlib-metadata,
  mock-ssh-server,
  pytest-asyncio,
  pytestCheckHook,
  setuptools,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "sshfs";
  version = "2025.10.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "fsspec";
    repo = "sshfs";
    tag = version;
    hash = "sha256-IG+/aXM6F+sNtxmhgiaD6OXhRpbiCm0zW2ki0y8nuLE=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    asyncssh
    fsspec
  ];

  optional-dependencies = {
    bcrypt = [ asyncssh ] ++ asyncssh.optional-dependencies.bcrypt;
    fido2 = [ asyncssh ] ++ asyncssh.optional-dependencies.fido2;
    gssapi = [ asyncssh ] ++ asyncssh.optional-dependencies.gssapi;
    libnacl = [ asyncssh ] ++ asyncssh.optional-dependencies.libnacl;
    pkcs11 = [ asyncssh ] ++ asyncssh.optional-dependencies.pkcs11;
    pyopenssl = [ asyncssh ] ++ asyncssh.optional-dependencies.pyOpenSSL;
  };

  __darwinAllowLocalNetworking = true;

  nativeCheckInputs = [
    importlib-metadata
    mock-ssh-server
    pytest-asyncio
    pytestCheckHook
  ];

  disabledTests = [
    # Test requires network access
    "test_config_expansions"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # Test fails with sandbox enabled
    "test_checksum"
  ];

  pythonImportsCheck = [ "sshfs" ];

  meta = with lib; {
    description = "SSH/SFTP implementation for fsspec";
    homepage = "https://github.com/fsspec/sshfs/";
    changelog = "https://github.com/fsspec/sshfs/releases/tag/${src.tag}";
    license = licenses.asl20;
    maintainers = with maintainers; [ melling ];
  };
}
