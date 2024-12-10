{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  paho-mqtt_2,
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
    rev = "refs/tags/v${version}";
    hash = "sha256-jTScDPTj7aIQcGuL2g8MvuYln6iaj6abEyCfd8vvT2I=";
  };

  postPatch = ''
    substituteInPlace weconnect_mqtt/__version.py \
      --replace-fail "0.0.0dev" "${version}"
    substituteInPlace requirements.txt \
      --replace-fail "weconnect[Images]~=" "weconnect>="
    substituteInPlace pytest.ini \
      --replace-fail "--cov=weconnect_mqtt --cov-config=.coveragerc --cov-report html" "" \
      --replace-fail "pytest-cov" ""
  '';

  pythonRelaxDeps = [ "python-dateutil" ];

  build-system = [ setuptools ];

  dependencies = [
    paho-mqtt_2
    python-dateutil
    weconnect
  ] ++ weconnect.optional-dependencies.Images;

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "weconnect_mqtt" ];

  meta = {
    description = "Python client that publishes data from Volkswagen WeConnect";
    homepage = "https://github.com/tillsteinbach/WeConnect-mqtt";
    changelog = "https://github.com/tillsteinbach/WeConnect-mqtt/releases/tag/v${version}";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "weconnect-mqtt";
  };
}
