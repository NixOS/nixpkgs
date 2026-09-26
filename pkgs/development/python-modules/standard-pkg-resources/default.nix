{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  setuptools-scm,
  jaraco-text,
  packaging,
  platformdirs,
  jaraco-envs,
  jaraco-path,
  pytestCheckHook,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage rec {
  pname = "standard-pkg-resources";
  version = "1.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "stephenfin";
    repo = "standard-pkg_resources";
    tag = "v${version}";
    hash = "sha256-MdibVeBssPa/kiNAw7f4jTl4Y6JKFnDLshvrc/cFWXw=";
  };

  # This filter references the coverage module directly; drop it instead of pulling in coverage/pytest-cov as a dependency.
  postPatch = ''
    substituteInPlace pytest.ini \
      --replace-fail "	ignore:Couldn't import C tracer:coverage.exceptions.CoverageWarning" ""
  '';

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    jaraco-text
    packaging
    platformdirs
  ];

  nativeCheckInputs = [
    jaraco-envs
    jaraco-path
    pytestCheckHook
    writableTmpDirAsHomeHook
  ];

  disabledTests = [
    # Fails against current setuptools_scm: it warns when a distribution's version is already set before it tries to infer one, which this test doesn't expect.
    "test_version_resolved_from_egg_info"
    # Requires internet access, unavailable in the Nix build sandbox.
    "test_interop_pkg_resources_iter_entry_points"
  ];

  pythonImportsCheck = [ "pkg_resources" ];

  meta = {
    description = "Standalone redistribution of pkg_resources, extracted from setuptools";
    homepage = "https://github.com/stephenfin/standard-pkg_resources";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ a-peirogon ];
  };
}
