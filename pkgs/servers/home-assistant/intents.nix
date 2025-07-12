{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,

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
  version = "2025.6.23";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "home-assistant";
    repo = "intents-package";
    rev = "refs/tags/${version}";
    fetchSubmodules = true;
    hash = "sha256-0xFa4Xz2zjN5EQVd9XafkUvroAH4AIiF/9bqFAZcJ9U=";
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
    # https://github.com/home-assistant/intents-package/blob/main/script/package#L23-L24
    PACKAGE_DIR=$out/${python.sitePackages}/home_assistant_intents
    ${python.pythonOnBuildForHost.interpreter} script/merged_output.py $PACKAGE_DIR/data
    ${python.pythonOnBuildForHost.interpreter} script/write_languages.py $PACKAGE_DIR/data > $PACKAGE_DIR/languages.py
  '';

  nativeCheckInputs = [
    pytest-xdist
    pytestCheckHook
  ];

  pytestFlagsArray = [
    "intents/tests"
  ];

  # requires hassil 3.0.0, but Home Assistant is stuck on 2.2.3
  doCheck = false;

  meta = with lib; {
    changelog = "https://github.com/home-assistant/intents/releases/tag/${version}";
    description = "Intents to be used with Home Assistant";
    homepage = "https://github.com/home-assistant/intents";
    license = licenses.cc-by-40;
    teams = [ teams.home-assistant ];
  };
}
