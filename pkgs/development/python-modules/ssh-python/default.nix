{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  cython,
  openssl,
  zlib,
  libssh,
}:

buildPythonPackage rec {
  pname = "ssh-python";
  version = "1.1.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "ParallelSSH";
    repo = "ssh-python";
    tag = version;
    hash = "sha256-kidz4uHT5C8TUROLGQUHihemYtwOoWZQNw7ElbwYKLM=";
  };

  build-system = [ setuptools ];
  nativeBuildInputs = [
    cython
  ];
  buildInputs = [
    openssl
    zlib
    libssh
  ];

  env = {
    SYSTEM_LIBSSH = true;
  };

  pythonImportsCheck = [ "ssh" ];

  meta = {
    description = "Python bindings for libssh C library";
    homepage = "https://github.com/ParallelSSH/ssh-python";
    changelog = "https://github.com/ParallelSSH/ssh-python/blob/${version}/Changelog.rst";
    license = lib.licenses.lgpl21Only;
    maintainers = with lib.maintainers; [ infinidoge ];
  };
}
