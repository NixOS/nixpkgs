{
  buildPythonPackage,
  coverage,
  docutils,
  fetchFromGitHub,
  html5lib,
  httpx2,
  jinja2,
  lib,
  meson,
  meson-python,
  ninja,
  pyperf,
  pyprojectVersionPatchHook,
  pytest-codspeed,
  pytest-mock,
  pytestCheckHook,
  python-sbom,
  tenacity,
  tinycss2,
}:

let
  html5lib-tests = fetchFromGitHub {
    owner = "html5lib";
    repo = "html5lib-tests";
    rev = "9fb614afaa42ce8787840f057b32084308e76549";
    hash = "sha256-I9Sp8wCO0oXRzdmIsR889fSlzM8GXUoDc7tFUuDBmKk=";
  };
in
buildPythonPackage (finalAttrs: {
  pname = "turbohtml";
  version = "1.16.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tox-dev";
    repo = "turbohtml";
    tag = finalAttrs.version;
    hash = "sha256-UhGdE/hX5djJunYsUHXdt+KjJnESmbcWTwI0DGRqbC0=";
  };

  postPatch = ''
    rmdir tests/html5lib-tests
    ln -s ${html5lib-tests} tests/html5lib-tests

    patchShebangs tools

    substituteInPlace pyproject.toml \
      --replace-fail "\"patchelf>=0.11; sys_platform=='linux'\"," ""
  '';

  nativeBuildInputs = [
    pyprojectVersionPatchHook
  ];

  build-system = [
    meson
    meson-python
    ninja
    python-sbom
  ];

  pythonImportsCheck = [ "turbohtml" ];

  nativeCheckInputs = [
    coverage # imported in tests/test_fuzz_round_trip_cli.py
    docutils
    html5lib
    httpx2
    jinja2
    pyperf
    pytest-codspeed
    pytest-mock
    pytestCheckHook
    tenacity
    tinycss2
  ];

  disabledTestPaths = [
    # tests modify $PYTHONPATH
    "tests/test_fuzz_release_diff.py"
    # we cannot generate the version from git
    "tests/build/test_generate_version.py"
    # tests depend on submodules
    "tests/_html/url/test_idna.py"
    "tests/conformance"
    "tests/url/test_idna.py"
  ];

  disabledTests = [
    # tests expect turbohtml to be imported from src
    "test_reachability_cli"
    "test_reachability_matches_path_suffix_only"
    "test_reachability_target_functions_follow_registry"
    "test_reachability_unreached_names_zero_coverage"
    "test_reachability_uses_public_function_source"
  ];

  meta = {
    changelog = "https://github.com/tox-dev/turbohtml/blob/${finalAttrs.src.tag}/docs/changelog.rst";
    description = "Fast, fully typed HTML toolkit for Python, powered by a C-accelerated core";
    homepage = "https://github.com/tox-dev/turbohtml";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.dotlambda ];
  };
})
