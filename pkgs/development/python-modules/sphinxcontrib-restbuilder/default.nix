{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  gitUpdater,
  setuptools,
  sphinx,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "sphinxcontrib-restbuilder";
  version = "0.3";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "sphinx-contrib";
    repo = "restbuilder";
    tag = finalAttrs.version;
    hash = "sha256-gm3TxcKorRBn1UcqlZtfjBAshNTE1smgLseSM7dddC0=";
  };

  build-system = [ setuptools ];

  dependencies = [ sphinx ];

  postPatch = ''
    # pkg_resources.declare_namespace shadows other sphinxcontrib.* packages
    substituteInPlace setup.py \
      --replace-fail "from setuptools import setup, find_packages" "from setuptools import setup, find_namespace_packages" \
      --replace-fail "packages=find_packages(exclude=['tests'])," "packages=find_namespace_packages(exclude=['tests*'])," \
      --replace-fail "namespace_packages=['sphinxcontrib']," ""
    rm -f sphinxcontrib/__init__.py
    # Sphinx 9: versionadded wording is "Added in", goldens still say "New in"
    substituteInPlace tests/expected/sphinx-directives/versionadded.rst \
      --replace-fail "New in version" "Added in version"
  '';

  nativeCheckInputs = [ pytestCheckHook ];

  pythonNamespaces = [ "sphinxcontrib" ];

  pythonImportsCheck = [ "sphinxcontrib.writers.rst" ];

  passthru.updateScript = gitUpdater { };

  meta = {
    description = "Sphinx extension to output reST files";
    homepage = "https://github.com/sphinx-contrib/restbuilder";
    changelog = "https://github.com/sphinx-contrib/restbuilder/blob/${finalAttrs.version}/CHANGES.rst";
    license = lib.licenses.bsd2;
    maintainers = [ lib.maintainers.lucasew ];
    teams = [ lib.teams.ngi ];
  };
})
