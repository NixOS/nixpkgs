{
  buildPythonPackage,
  lib,
  fetchFromGitHub,
  setuptools,
  cython,
  openssl,
  zlib,
  libssh2,
}:

buildPythonPackage rec {
  pname = "ssh2-python";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "ParallelSSH";
    repo = "ssh2-python";
    tag = version;
    hash = "sha256-v3+4OsBd0ug2ELdywjpIwE9UwQ1eIT49HshYZxtMg7A=";
  };

  build-system = [ setuptools ];
  dependencies = [
    cython
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
    license = lib.licenses.lgpl21Only;
    maintainers = with lib.maintainers; [ infinidoge ];
  };
}
