{ lib
, asyncssh
, buildPythonPackage
, dulwich
, fetchFromGitHub
, fsspec
, funcy
, GitPython
, pathspec
, pygit2
, pygtrie
, pythonOlder
}:

buildPythonPackage rec {
  pname = "scmrepo";
  version = "0.0.22";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "iterative";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-hV0BusvuJUEGfmue7OHR3YYmpBcFTgbQE7UuHmTUBo0=";
  };

  propagatedBuildInputs = [
    asyncssh
    dulwich
    fsspec
    funcy
    GitPython
    pathspec
    pygit2
    pygtrie
  ];

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace "asyncssh>=2.7.1,<2.9" "asyncssh>=2.7.1"
  '';

  # Requires a running Docker instance
  doCheck = false;

  pythonImportsCheck = [
    "scmrepo"
  ];

  meta = with lib; {
    description = "SCM wrapper and fsspec filesystem";
    homepage = "https://github.com/iterative/scmrepo";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
