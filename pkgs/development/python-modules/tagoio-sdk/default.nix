{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  pytestCheckHook,
  python-dateutil,
  python-socketio,
  requests,
  requests-mock,
  requests-toolbelt,
  sseclient-py,
}:

buildPythonPackage rec {
  pname = "tagoio-sdk";
<<<<<<< HEAD
  version = "5.1.0";
=======
  version = "5.0.4";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tago-io";
    repo = "sdk-python";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-jKgH78ZFb9hr7rb71mF7qIpfDzCCWLlqUJVjO88dbYc=";
=======
    hash = "sha256-a+cwDPYLfDgMiWf7jpFszwdueFbnfNgwZLWQrffjBqU=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  pythonRelaxDeps = [ "requests" ];

  build-system = [ hatchling ];

  dependencies = [
    aiohttp
    python-dateutil
    python-socketio
    requests
    requests-toolbelt
    sseclient-py
  ];

  nativeCheckInputs = [
    requests-mock
    pytestCheckHook
  ];

  pythonImportsCheck = [ "tagoio_sdk" ];

<<<<<<< HEAD
  meta = {
    description = "Module for interacting with Tago.io";
    homepage = "https://github.com/tago-io/sdk-python";
    changelog = "https://github.com/tago-io/sdk-python/releases/tag/${src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
=======
  meta = with lib; {
    description = "Module for interacting with Tago.io";
    homepage = "https://github.com/tago-io/sdk-python";
    changelog = "https://github.com/tago-io/sdk-python/releases/tag/${src.tag}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
