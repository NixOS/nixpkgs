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

buildPythonPackage (finalAttrs: {
  pname = "home-assistant-intents";
  version = "2026.8.28";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "OHF-Voice";
    repo = "intents-package";
    tag = finalAttrs.version;
    fetchSubmodules = true;
    hash = "sha256-9VVTpMhlbhHVhqZ5ujZZNI+qqkhjRM+B1W3Uruy/bn8=";
  };

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
    # https://github.com/OHF-Voice/intents-package/issues/12
    license = lib.licenses.cc-by-40;
    teams = [ lib.teams.home-assistant ];
  };
})
