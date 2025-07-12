{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools-scm,
  tqdm,
  colorama,
}:

buildPythonPackage {
  pname = "tqdm-multiprocess";
  version = "0.0.11";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "EleutherAI";
    repo = "tqdm-multiprocess";
    rev = "fccefc473595055bf3a5e74bcf8a75b3a9517638";
    hash = "sha256-nQeFPwF5OasOYrVs7kLG/Uz6pf1FKxar4ygggo8s4ZM=";
  };

  build-system = [
    setuptools-scm
  ];

  dependencies = [
    colorama
    tqdm
  ];

  pythonImportsCheck = [
    "tqdm_multiprocess"
  ];

  meta = {
    description = "Support multiple worker processes, each with multiple tqdm progress bars, displaying them cleanly through the main process";
    homepage = "https://github.com/EleutherAI/tqdm-multiprocess";
    license = [ lib.licenses.mit ];
    maintainers = [ lib.maintainers.booxter ];
  };
}
