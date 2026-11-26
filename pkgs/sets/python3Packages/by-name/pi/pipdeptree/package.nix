{
  lib,
  buildPythonPackage,
  cargo,
  fetchFromGitHub,
  gitMinimal,
  graphviz-nox,
  hatch-fancy-pypi-readme,
  meson-python,
  meson,
  nab-index,
  nab-project,
  nab,
  ninja,
  pytest-mock,
  pytestCheckHook,
  python-sbom,
  rustc,
  rustPlatform,
  scikit-build-core,
  setuptools-scm,
  stdenvNoCC,
  versionCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "pipdeptree";
  version = "4.2.14";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tox-dev";
    repo = "pipdeptree";
    tag = finalAttrs.version;
    hash = "sha256-kneg+woQFZt1wqTvF/DEqd7OXLZ5vUk2QA0MXUKolEI=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-iLeSUqvGf0MsrpQOV52p3uqN9TlW0g71LIxBEqEU8zg=";
  };

  postPatch = ''
    patchShebangs tools

    substituteInPlace pyproject.toml \
      --replace-fail "\"patchelf>=0.11; sys_platform=='linux'\"," ""
  '';

  nativeBuildInputs = [
    cargo
    rustc
    rustPlatform.cargoSetupHook
  ];

  build-system = [
    hatch-fancy-pypi-readme
    meson
    meson-python
    ninja
    python-sbom
    scikit-build-core
    setuptools-scm
  ];

  dontUseMesonConfigure = true;

  env.PIPDEPTREE_VERSION = finalAttrs.version;

  dependencies = [
    nab
    nab-index
    nab-project
  ];

  nativeCheckInputs = [
    gitMinimal
    graphviz-nox
    pytest-mock
    pytestCheckHook
    versionCheckHook
  ];

  pythonImportsCheck = [ "pipdeptree" ];

  meta = {
    description = "Command line utility to show dependency tree of packages";
    homepage = "https://github.com/tox-dev/pipdeptree";
    changelog = "https://github.com/tox-dev/pipdeptree/blob/${finalAttrs.src.rev}/docs/changelog.rst";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      charlesbaynham
      mdaniels5757
    ];
    mainProgram = "pipdeptree";
  };
})
