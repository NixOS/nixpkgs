{
  lib,
  aiohttp-retry,
  asyncssh,
  buildPythonPackage,
  dulwich,
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
  tqdm,
}:

buildPythonPackage rec {
  pname = "scmrepo";
  version = "3.5.2";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "iterative";
    repo = "scmrepo";
    tag = version;
    hash = "sha256-dZukbMrjUwJUHIBibOFrzBEs4TT0ljm4cnmKQ7rXMug=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    aiohttp-retry
    asyncssh
    dulwich
    fsspec
    funcy
    gitpython
    pathspec
    pygit2
    pygtrie
    tqdm
  ];

  # Requires a running Docker instance
  doCheck = false;

  pythonImportsCheck = [ "scmrepo" ];

  meta = with lib; {
    description = "SCM wrapper and fsspec filesystem";
    homepage = "https://github.com/iterative/scmrepo";
    changelog = "https://github.com/iterative/scmrepo/releases/tag/${src.tag}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
