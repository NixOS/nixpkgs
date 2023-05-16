<<<<<<< HEAD
{ stdenv
, lib
=======
{ lib
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, asyncssh
, bcrypt
, buildPythonPackage
, fetchFromGitHub
, fsspec
, mock-ssh-server
, pytest-asyncio
, pytestCheckHook
<<<<<<< HEAD
, setuptools
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "sshfs";
<<<<<<< HEAD
  version = "2023.7.0";
=======
  version = "2023.4.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "fsspec";
    repo = pname;
    rev = "refs/tags/${version}";
<<<<<<< HEAD
    hash = "sha256-XKBpB3ackquVKsdF8b/45Kaz5Y2ussOl0o0HkD+k9tM=";
=======
    hash = "sha256-qoOqKXtmavKgfbg6bBEeZb+n1RVyZSxqhKIQsToxDUU=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [
<<<<<<< HEAD
    setuptools
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    setuptools-scm
  ];

  propagatedBuildInputs = [
    asyncssh
    bcrypt
    fsspec
  ];

<<<<<<< HEAD
  __darwinAllowLocalNetworking = true;

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  nativeCheckInputs = [
    mock-ssh-server
    pytest-asyncio
    pytestCheckHook
  ];

<<<<<<< HEAD
  disabledTests = lib.optionals stdenv.isDarwin [
    # test fails with sandbox enabled
    "test_checksum"
  ];

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
