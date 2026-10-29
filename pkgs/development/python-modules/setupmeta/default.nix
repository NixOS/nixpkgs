{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  git,
  mock,
  pep440,
  pip,
  pytestCheckHook,
  setuptools,
  six,
}:

buildPythonPackage (finalAttrs: {
  pname = "setupmeta";
  version = "4.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "codrsquad";
    repo = "setupmeta";
    tag = "v${finalAttrs.version}";
    hash = "sha256-aTSb6wy272Rt3axxG/4gidY515G6g4sQWzBZ31qH9jA=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail 'args["versioning"] = "dev"' 'args["version"] = "${finalAttrs.version}"'
  '';

  preBuild = ''
    export PYGRADLE_PROJECT_VERSION=${finalAttrs.version};
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

  meta = {
    description = "Python module to simplify setup.py files";
    homepage = "https://github.com/codrsquad/setupmeta";
    changelog = "https://github.com/codrsquad/setupmeta/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
