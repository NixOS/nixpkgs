{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  cython,
  openssl,
  zlib,
  libssh2,
}:

buildPythonPackage rec {
  pname = "ssh2-python";
  version = "1.1.2";

  src = fetchFromGitHub {
    owner = "ParallelSSH";
    repo = "ssh2-python";
    tag = version;
    hash = "sha256-nNMe7BTHI4O9Ueyq2YxtHat4BrrtiWGFkKHwUu/NtkM=";
  };

  build-system = [ setuptools ];
  nativeBuildInputs = [
    cython
  ];
  buildInputs = [
    openssl
    zlib
    libssh2
  ];

  env = {
    SYSTEM_LIBSSH2 = true;
  };

  pythonImportsCheck = [ "ssh2" ];

  meta = {
    description = "Python bindings for libssh2 C library";
    homepage = "https://github.com/ParallelSSH/ssh2-python";
    changelog = "https://github.com/ParallelSSH/ssh2-python/blob/${version}/Changelog.rst";
    license = lib.licenses.lgpl21Only;
    maintainers = with lib.maintainers; [ infinidoge ];
  };
}
