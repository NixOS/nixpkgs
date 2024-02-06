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
  version = "2023.10.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "fsspec";
    repo = "sshfs";
    rev = "refs/tags/${version}";
    hash = "sha256-6MueDHR+jZFDZg4zufEVhBtSwcgDd7KnW9gJp2hDu0A=";
  };

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
