{
  lib,
  ascii-magic,
  buildPythonPackage,
  fetchFromGitHub,
  oauthlib,
  pillow,
<<<<<<< HEAD
  pyjwt,
  pytest-cov-stub,
  pytestCheckHook,
=======
  pytest-cov-stub,
  pytestCheckHook,
  pythonOlder,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  requests,
  setuptools,
}:

buildPythonPackage rec {
  pname = "weconnect";
<<<<<<< HEAD
  version = "0.60.11";
  pyproject = true;

=======
  version = "0.60.8";
  pyproject = true;

  disabled = pythonOlder "3.8";

>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  src = fetchFromGitHub {
    owner = "tillsteinbach";
    repo = "WeConnect-python";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-llAWCjhP/fwI+H8BRpMYxba8jC+WDc66xkUDwT3NHcA=";
=======
    hash = "sha256-o8g409R+3lXlwPiDFi9eCzTwcDcZhMEMcc8a1YvlomM=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  postPatch = ''
    substituteInPlace weconnect/__version.py \
      --replace-fail "0.0.0dev" "${version}"
    substituteInPlace setup.py \
      --replace-fail "setup_requires=SETUP_REQUIRED" "setup_requires=[]" \
      --replace-fail "tests_require=TEST_REQUIRED" "tests_require=[]"
    substituteInPlace pytest.ini \
      --replace-fail "required_plugins = pytest-cov" ""
  '';

  build-system = [ setuptools ];

  dependencies = [
    oauthlib
<<<<<<< HEAD
    pyjwt
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    requests
  ];

  pythonRelaxDeps = [ "oauthlib" ];

  optional-dependencies = {
    Images = [
      ascii-magic
      pillow
    ];
  };

  nativeCheckInputs = [
    pytest-cov-stub
    pytestCheckHook
  ];

  pythonImportsCheck = [ "weconnect" ];

<<<<<<< HEAD
  meta = {
    description = "Python client for the Volkswagen WeConnect Services";
    homepage = "https://github.com/tillsteinbach/WeConnect-python";
    changelog = "https://github.com/tillsteinbach/WeConnect-python/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
=======
  meta = with lib; {
    description = "Python client for the Volkswagen WeConnect Services";
    homepage = "https://github.com/tillsteinbach/WeConnect-python";
    changelog = "https://github.com/tillsteinbach/WeConnect-python/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
