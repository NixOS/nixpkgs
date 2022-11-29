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
, setuptools
}:

buildPythonPackage rec {
  pname = "scmrepo";
  version = "0.1.3";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "iterative";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-YivsP5c0fnpm/0VCFfyH054LYAQbyEdH+wZTRxsCAY4=";
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
    GitPython
    pathspec
    pygit2
    pygtrie
  ];

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
