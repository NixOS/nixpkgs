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
  version = "2024.4.24";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "home-assistant";
    repo = "intents-package";
    # https://github.com/home-assistant/intents-package/issues/3
    rev = "a68176a189c3def87cb11ad39baacea2440ce668";
    hash = "sha256-SUIJWoA0ltg+bjYn4J5kvAk4Eh23uxEcdxonkTSV0m0=";
    fetchSubmodules = true;
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "setuptools~=62.3" "setuptools" \
      --replace-fail "wheel~=0.37.1" "wheel"
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

  meta = with lib; {
    description = "Intents to be used with Home Assistant";
    homepage = "https://github.com/home-assistant/intents";
    license = licenses.cc-by-40;
    maintainers = teams.home-assistant.members;
  };
}
