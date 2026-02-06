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

buildPythonPackage rec {
  pname = "home-assistant-intents";
  version = "2026.1.28";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "OHF-Voice";
    repo = "intents-package";
    tag = version;
    fetchSubmodules = true;
    hash = "sha256-5n2B9HeEiuNHlaTHzpl18zaXB3ocWKC2Bs4aEoda7aQ=";
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
    changelog = "https://github.com/OHF-Voice/intents-package/releases/tag/${src.tag}";
    description = "Intents to be used with Home Assistant";
    homepage = "https://github.com/OHF-Voice/intents-package";
    license = lib.licenses.cc-by-40;
    teams = [ lib.teams.home-assistant ];
  };
}
