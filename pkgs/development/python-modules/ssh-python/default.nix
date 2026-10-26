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

buildPythonPackage (finalAttrs: {
  pname = "ssh-python";
  version = "1.2.0.post1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ParallelSSH";
    repo = "ssh-python";
    tag = finalAttrs.version;
    hash = "sha256-ix6UzyC/mFDVOvfJujwppijmsTrwNtuDAkmikrKKc2o=";
  };

  build-system = [ setuptools ];

  nativeBuildInputs = [ cython ];

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
    changelog = "https://github.com/ParallelSSH/ssh-python/blob/${finalAttrs.src.tag}/Changelog.rst";
    license = lib.licenses.lgpl21Only;
    maintainers = with lib.maintainers; [ infinidoge ];
  };
})
