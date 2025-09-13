{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  gitpython,
  poetry-core,
  pyelftools,
  requests,
}:

buildPythonPackage {
  pname = "sebaubuntu-libs";
  version = "1.5.0-unstable-2025-07-25";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "sebaubuntu-python";
    repo = "sebaubuntu_libs";
    rev = "d71307e3bf57d2941e729aa5aa67d7d37b217d89";
    hash = "sha256-jbgYdAvYZH6Rqfof9NIYk53ffeKh3WbZ96YellGWbLI=";
  };

  build-system = [
    poetry-core
  ];

  dependencies = [
    gitpython
    pyelftools
    requests
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "sebaubuntu_libs" ];

  meta = {
    description = "SebaUbuntu's shared libs";
    homepage = "https://github.com/sebaubuntu-python/sebaubuntu_libs";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ ungeskriptet ];
  };
}
