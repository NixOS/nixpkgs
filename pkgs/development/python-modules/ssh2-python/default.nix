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
  version = "1.1.2.post1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "ParallelSSH";
    repo = "ssh2-python";
    tag = version;
    hash = "sha256-LHIj0lSAMJ+tUvIyMl0xT/i0N4U+HbiiD62WIXzboMU=";
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
    changelog = "https://github.com/ParallelSSH/ssh2-python/blob/${src.tag}/Changelog.rst";
    license = lib.licenses.lgpl21Only;
    maintainers = with lib.maintainers; [ infinidoge ];
  };
}
