{ stdenv
, lib
, asyncssh
, bcrypt
, buildPythonPackage
, fetchFromGitHub
, fsspec
, mock-ssh-server
, pytest-asyncio
, pytestCheckHook
, setuptools
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "sshfs";
  version = "2023.7.0";

  src = fetchFromGitHub {
    owner = "fsspec";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-XKBpB3ackquVKsdF8b/45Kaz5Y2ussOl0o0HkD+k9tM=";
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [
    setuptools
    setuptools-scm
  ];

  propagatedBuildInputs = [
    asyncssh
    bcrypt
    fsspec
  ];

  __darwinAllowLocalNetworking = true;

  nativeCheckInputs = [
    mock-ssh-server
    pytest-asyncio
    pytestCheckHook
  ];

  disabledTests = lib.optionals stdenv.isDarwin [
    # test fails with sandbox enabled
    "test_checksum"
  ];

  pythonImportsCheck = [
    "sshfs"
  ];

  meta = with lib; {
    description = "SSH/SFTP implementation for fsspec";
    homepage = "https://github.com/fsspec/sshfs/";
    changelog = "https://github.com/fsspec/sshfs/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ melling ];
  };
}
