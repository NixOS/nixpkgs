{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
}:

buildPythonPackage rec {
  pname = "stgpytools";
  version = "1.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Setsugennoao";
    repo = "stgpytools";
    rev = "refs/tags/v${version}";
    hash = "sha256-YxDQmtyJgYDUcvMxQ4KqA4yYLO8N4fzCyayyBnuZjf0=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [
    "stgpytools"
    "stgpytools.enums"
    "stgpytools.exceptions"
    "stgpytools.functions"
    "stgpytools.types"
    "stgpytools.utils"
  ];

  doCheck = false; # no tests

  meta = {
    description = "Collection of stuff that's useful in general python programming";
    homepage = "https://github.com/Setsugennoao/stgpytools";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sigmanificient ];
  };
}
