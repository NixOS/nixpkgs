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
  setuptools,
  setuptools-scm,
  tqdm,
}:

buildPythonPackage (finalAttrs: {
  pname = "scmrepo";
  version = "3.6.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "treeverse";
    repo = "scmrepo";
    tag = finalAttrs.version;
    hash = "sha256-E7BHdLDS57r/UbSA62lfr3z+5sqFTPRzwfFLIITeSs0=";
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

  meta = {
    description = "SCM wrapper and fsspec filesystem";
    homepage = "https://github.com/treeverse/scmrepo";
    changelog = "https://github.com/treeverse/scmrepo/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
})
