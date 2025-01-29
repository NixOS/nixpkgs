{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  paho-mqtt_2,
  pytest-cov-stub,
  pytestCheckHook,
  python-dateutil,
  pythonOlder,
  setuptools,
  weconnect,
}:

buildPythonPackage rec {
  pname = "weconnect-mqtt";
  version = "0.49.2";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "tillsteinbach";
    repo = "WeConnect-mqtt";
    tag = "v${version}";
    hash = "sha256-jTScDPTj7aIQcGuL2g8MvuYln6iaj6abEyCfd8vvT2I=";
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
    paho-mqtt_2
    python-dateutil
    weconnect
  ] ++ weconnect.optional-dependencies.Images;

  nativeCheckInputs = [
    pytest-cov-stub
    pytestCheckHook
  ];

  pythonImportsCheck = [ "weconnect_mqtt" ];

  meta = {
    description = "Python client that publishes data from Volkswagen WeConnect";
    homepage = "https://github.com/tillsteinbach/WeConnect-mqtt";
    changelog = "https://github.com/tillsteinbach/WeConnect-mqtt/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "weconnect-mqtt";
  };
}
