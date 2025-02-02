{
  lib,
  asyncssh,
  buildPythonPackage,
  dulwich,
  dvc-http,
  dvc-objects,
  fetchFromGitHub,
  fsspec,
  funcy,
  gitpython,
  pathspec,
  pygit2,
  pygtrie,
  pythonOlder,
  setuptools,
  setuptools-scm,
  shortuuid,
}:

buildPythonPackage rec {
  pname = "scmrepo";
  version = "3.3.10";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "iterative";
    repo = "scmrepo";
    tag = version;
    hash = "sha256-BiLxILHbq5Q8iIE2yMBNlnqqFMoRe9z+Bn/FMaA7gtI=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    asyncssh
    dulwich
    dvc-http
    dvc-objects
    fsspec
    funcy
    gitpython
    pathspec
    pygit2
    pygtrie
    shortuuid
  ];

  # Requires a running Docker instance
  doCheck = false;

  pythonImportsCheck = [ "scmrepo" ];

  meta = with lib; {
    description = "SCM wrapper and fsspec filesystem";
    homepage = "https://github.com/iterative/scmrepo";
    changelog = "https://github.com/iterative/scmrepo/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
