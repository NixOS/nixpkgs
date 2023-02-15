{ lib
, asyncssh
, buildPythonPackage
, dulwich
, fetchFromGitHub
, fsspec
, funcy
, gitpython
, pathspec
, pygit2
, pygtrie
, pythonOlder
, setuptools
, shortuuid
}:

buildPythonPackage rec {
  pname = "scmrepo";
  version = "0.1.9";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "iterative";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-WXePQMHCAmcGUHNNHBaqNQisewMUR87iJC0K2ltYVBE=";
  };

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace "asyncssh>=2.7.1,<2.9" "asyncssh>=2.7.1" \
      --replace "pathspec>=0.9.0,<0.10.0" "pathspec"
  '';

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    asyncssh
    dulwich
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

  pythonImportsCheck = [
    "scmrepo"
  ];

  meta = with lib; {
    description = "SCM wrapper and fsspec filesystem";
    homepage = "https://github.com/iterative/scmrepo";
    changelog = "https://github.com/iterative/scmrepo/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
