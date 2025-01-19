{
  buildPythonPackage,
  lib,
  fetchFromGitHub,
  setuptools,
  cython,
  openssl,
  zlib,
  libssh,
}:

buildPythonPackage rec {
  pname = "ssh-python";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "ParallelSSH";
    repo = "ssh-python";
    tag = version;
    hash = "sha256-tfx2oiluYaKNUZhUefIrlNPANnLgmpD59LreDqJkrHo=";
  };

  build-system = [ setuptools ];
  dependencies = [
    cython
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
    license = lib.licenses.lgpl21Only;
    maintainers = with lib.maintainers; [ infinidoge ];
  };
}
