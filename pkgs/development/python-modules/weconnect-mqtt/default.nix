{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  paho-mqtt,
  pytestCheckHook,
  python-dateutil,
  pythonOlder,
  setuptools,
  weconnect,
}:

buildPythonPackage rec {
  pname = "weconnect-mqtt";
  version = "0.48.4";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "tillsteinbach";
    repo = "WeConnect-mqtt";
    rev = "refs/tags/v${version}";
    hash = "sha256-Yv6CAGTDi4P9pImLxVk2QkZ014iqQ8UMBUeiyZWnYiQ=";
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
    paho-mqtt
    python-dateutil
    weconnect
  ] ++ weconnect.optional-dependencies.Images;

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "weconnect_mqtt" ];

  meta = with lib; {
    description = "Python client that publishes data from Volkswagen WeConnect";
    homepage = "https://github.com/tillsteinbach/WeConnect-mqtt";
    changelog = "https://github.com/tillsteinbach/WeConnect-mqtt/releases/tag/v${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
    mainProgram = "weconnect-mqtt";
  };
}
