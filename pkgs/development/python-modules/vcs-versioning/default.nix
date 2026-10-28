{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  packaging,
  setuptools,
  git,
  pytestCheckHook,
  vcs-versioning,
}:

buildPythonPackage (finalAttrs: {
  pname = "vcs-versioning";
  version = "2.3.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pypa";
    repo = "setuptools-scm";
    tag = "vcs-versioning-v${finalAttrs.version}";
    hash = "sha256-vuIALTydsT5ndYeFWGMuvNxmRMqj9txPbp29ImBdMFc=";
  };

  env.SETUPTOOLS_SCM_PRETEND_VERSION = finalAttrs.version;

  postPatch = ''
    pushd vcs-versioning
  '';

  build-system = [
    setuptools
  ];

  dependencies = [
    packaging
  ];

  pythonImportsCheck = [
    "vcs_versioning"
  ];

  doCheck = false; # infinite recursion with pytest

  nativeCheckInputs = [
    git
    pytestCheckHook
  ];

  pytestFlags = [ "-vvv" ];

  passthru.tests.pytest = vcs-versioning.overridePythonAttrs { doCheck = true; };

  meta = {
    changelog = "https://github.com/pypa/setuptools-scm/releases/tag/${finalAttrs.src.tag}";
    description = "The blessed package to manage your versions by scm tags";
    homepage = "https://github.com/pypa/setuptools-scm/tree/main/vcs-versioning";
    license = lib.licenses.mit;
    teams = [ lib.teams.python ];
  };
})
