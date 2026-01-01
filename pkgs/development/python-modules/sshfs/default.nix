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
<<<<<<< HEAD
  version = "2025.11.0";
=======
  version = "2025.10.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "fsspec";
    repo = "sshfs";
    tag = version;
<<<<<<< HEAD
    hash = "sha256-TrFrjORH6VebTBq+OHJUEr55DtjL58/b+qQLpbSU7MU=";
=======
    hash = "sha256-IG+/aXM6F+sNtxmhgiaD6OXhRpbiCm0zW2ki0y8nuLE=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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

<<<<<<< HEAD
  meta = {
    description = "SSH/SFTP implementation for fsspec";
    homepage = "https://github.com/fsspec/sshfs/";
    changelog = "https://github.com/fsspec/sshfs/releases/tag/${src.tag}";
    license = lib.licenses.asl20;
=======
  meta = with lib; {
    description = "SSH/SFTP implementation for fsspec";
    homepage = "https://github.com/fsspec/sshfs/";
    changelog = "https://github.com/fsspec/sshfs/releases/tag/${src.tag}";
    license = licenses.asl20;
    maintainers = with maintainers; [ melling ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
