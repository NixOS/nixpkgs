{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  paho-mqtt,
  pytest-cov-stub,
  pytestCheckHook,
  python-dateutil,
<<<<<<< HEAD
=======
  pythonOlder,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  setuptools,
  weconnect,
}:

buildPythonPackage rec {
  pname = "weconnect-mqtt";
<<<<<<< HEAD
  version = "0.49.5";
  pyproject = true;

=======
  version = "0.49.2";
  pyproject = true;

  disabled = pythonOlder "3.8";

>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  src = fetchFromGitHub {
    owner = "tillsteinbach";
    repo = "WeConnect-mqtt";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-69p7lAO7W+odrm1kLhvB8v4kNKx6IWBUSOQKgrxVCCY=";
=======
    hash = "sha256-jTScDPTj7aIQcGuL2g8MvuYln6iaj6abEyCfd8vvT2I=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
<<<<<<< HEAD
    changelog = "https://github.com/tillsteinbach/WeConnect-mqtt/releases/tag/${src.tag}";
=======
    changelog = "https://github.com/tillsteinbach/WeConnect-mqtt/releases/tag/v${version}";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "weconnect-mqtt";
  };
}
