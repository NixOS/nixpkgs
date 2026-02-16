{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  flexmock,
  git,
  pytestCheckHook,
  rpm,
  setuptools-scm,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "specfile";
  version = "0.39.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "packit";
    repo = "specfile";
    tag = finalAttrs.version;
    postFetch = ''
      # export-subst prevents reproducibility
      rm "$out/.git_archival.txt"
    '';
    hash = "sha256-apGGUVBFNRknQvyBCVZerw0/MctWDTDcz4y/7tRp46s=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [ rpm ];

  nativeCheckInputs = [
    git
    flexmock
    pytestCheckHook
  ];

  pythonImportsCheck = [ "specfile" ];

  disabledTests = [
    # AssertionError
    "test_update_tag"
    "test_shell_expansions"
  ];

  meta = {
    description = "Library for parsing and manipulating RPM spec files";
    homepage = "https://github.com/packit/specfile";
    changelog = "https://github.com/packit/specfile/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
