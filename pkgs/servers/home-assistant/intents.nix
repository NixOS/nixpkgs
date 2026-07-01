{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # codegen
  hassil,
  python,
  pyyaml,
  voluptuous,
  regex,
  jinja2,

  # tests
  pytest-xdist,
  pytestCheckHook,
}:

let
  intents = fetchFromGitHub {
    owner = "OHF-Voice";
    repo = "intents";
    rev = "4178d174018d408209879c44e98aa150335a1656";
    hash = "sha256-xMH3lZaI4sSvicSMFaGCeYlcr5SrhA8nB/krrN0kyQo=";
  };
in

buildPythonPackage (finalAttrs: {
  pname = "home-assistant-intents";
  version = "2026.6.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "OHF-Voice";
    repo = "intents-package";
    # https://github.com/OHF-Voice/intents-package/issues/14
    tag = "2026.5.5";
    fetchSubmodules = true;
    hash = "sha256-R6PPZSiDiFvB+lNxyuIHwMIgpQvVI0oqrucnw4jnYNU=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail '2026.5.5' '2026.6.1'

    rm -rf intents
    ln -sf ${intents} intents
  '';

  build-system = [
    setuptools

    # build-time codegen; https://github.com/home-assistant/intents/blob/main/requirements.txt#L1-L5
    hassil
    pyyaml
    voluptuous
    regex
    jinja2
  ];

  postInstall = ''
    # https://github.com/OHF-Voice/intents-package/blob/main/script/package#L23-L24
    PACKAGE_DIR=$out/${python.sitePackages}/home_assistant_intents
    ${python.pythonOnBuildForHost.interpreter} script/merged_output.py $PACKAGE_DIR/data
    ${python.pythonOnBuildForHost.interpreter} script/write_languages.py $PACKAGE_DIR/data > $PACKAGE_DIR/languages.py
  '';

  nativeCheckInputs = [
    pytest-xdist
    pytestCheckHook
  ];

  enabledTestPaths = [
    "intents/tests"
  ];

  meta = {
    changelog = "https://github.com/OHF-Voice/intents-package/releases/tag/${finalAttrs.src.tag}";
    description = "Intents to be used with Home Assistant";
    homepage = "https://github.com/OHF-Voice/intents-package";
    license = lib.licenses.asl20;
    teams = [ lib.teams.home-assistant ];
  };
})
