{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  sphinx,
  gitpython,
  gitMinimal,
  pytestCheckHook,
  sphinx-pytest,
  pytest-cov-stub,
}:
buildPythonPackage rec {
  pname = "sphinx-last-updated-by-git";
  version = "0.3.8";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mgeier";
    repo = "sphinx-last-updated-by-git";
    rev = "07ac1a98af2a927e773a65c6524ce83067c977b8";
    hash = "sha256-2TGFR11Ejh/9zpVC/TEdmMNaBt38wE5yeJeYixZSVUE=";
    fetchSubmodules = true;
    leaveDotGit = true;
  };

  build-system = [ setuptools ];

  dependencies = [
    sphinx
    gitpython
  ];

  postPatch = ''
    # we cant just substitute by matching `'git'` due to collisons
    substituteInPlace src/sphinx_last_updated_by_git.py \
      --replace-fail "'git', 'ls-tree'" " '${lib.getExe gitMinimal}', 'ls-tree'" \
      --replace-fail "'git', 'log'" "'${lib.getExe gitMinimal}', 'log'" \
      --replace-fail "'git', 'rev-parse'" "'${lib.getExe gitMinimal}', 'rev-parse'" \
  '';

  propagatedBuildInputs = [ gitMinimal ];

  nativeCheckInputs = [
    pytestCheckHook
    sphinx-pytest
    pytest-cov-stub
  ];

  disabledTests = [
    "test_no_git" # we hardcoded the git path

    "test_repo_shallow"
    "test_repo_shallow_without_warning"
  ];

  meta = {
    changelog = "https://github.com/mgeier/sphinx-last-updated-by-git/blob/${version}/NEWS.rst";
    description = "Get the last updated time for each Sphinx page from Git";
    homepage = "https://github.com/mgeier/sphinx-last-updated-by-git";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ sigmanificient ];
  };
}
