{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  git,
  mock,
  pep440,
  pip,
  pytestCheckHook,
  pythonOlder,
  setuptools,
  six,
}:

buildPythonPackage rec {
  pname = "setupmeta";
  version = "3.8.0";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "codrsquad";
    repo = "setupmeta";
    tag = "v${version}";
    hash = "sha256-2SKiIkwfmXVOQBKBNUmw4SjiVpyLjIMpSHNA9IQxqwY=";
  };

  preBuild = ''
    export PYGRADLE_PROJECT_VERSION=${version};
  '';

  build-system = [ setuptools ];

  nativeCheckInputs = [
    git
    mock
    pep440
    pip
    pytestCheckHook
    six
  ];

  preCheck = ''
    unset PYGRADLE_PROJECT_VERSION
  '';

  disabledTests = [
    # Tests want to scan site-packages
    "test_check_dependencies"
    "test_clean"
    "test_scenario"
    "test_git_versioning"
    # setuptools.installer and fetch_build_eggs are deprecated.
    # Requirements should be satisfied by a PEP 517 installer.
    "test_brand_new_project"
  ];

  pythonImportsCheck = [ "setupmeta" ];

  meta = with lib; {
    description = "Python module to simplify setup.py files";
    homepage = "https://github.com/codrsquad/setupmeta";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
