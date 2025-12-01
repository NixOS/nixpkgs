{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  paho-mqtt,
  pytest-cov-stub,
  pytestCheckHook,
  python-dateutil,
  setuptools,
  weconnect,
}:

buildPythonPackage rec {
  pname = "weconnect-mqtt";
  version = "0.49.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tillsteinbach";
    repo = "WeConnect-mqtt";
    tag = "v${version}";
    hash = "sha256-I1//jAF7Exz5d+5B3lhcdokh7xlUoJUFryqTQwFqWuM=";
  };

  postPatch = ''
    substituteInPlace weconnect_mqtt/__version.py \
      --replace-fail "0.0.0dev" "${version}"
    substituteInPlace requirements.txt \
      --replace-fail "weconnect[Images]~=" "weconnect>="
    substituteInPlace pytest.ini \
      --replace-fail "required_plugins = pytest-cov" ""
  '';

  pythonRelaxDeps = [ "python-dateutil" ];

  build-system = [ setuptools ];

  dependencies = [
    paho-mqtt
    python-dateutil
    weconnect
  ]
  ++ weconnect.optional-dependencies.Images;

  nativeCheckInputs = [
    pytest-cov-stub
    pytestCheckHook
  ];

  pythonImportsCheck = [ "weconnect_mqtt" ];

  meta = {
    description = "Python client that publishes data from Volkswagen WeConnect";
    homepage = "https://github.com/tillsteinbach/WeConnect-mqtt";
    changelog = "https://github.com/tillsteinbach/WeConnect-mqtt/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "weconnect-mqtt";
  };
}
