{
  lib,
  ascii-magic,
  buildPythonPackage,
  fetchFromGitHub,
  oauthlib,
  pillow,
  pyjwt,
  pytest-cov-stub,
  pytestCheckHook,
  requests,
  setuptools,
}:

buildPythonPackage rec {
  pname = "weconnect";
  version = "0.60.10";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tillsteinbach";
    repo = "WeConnect-python";
    tag = "v${version}";
    hash = "sha256-ZvJoZ4mUNkUJ5sOxOHDsuxGZO2s3PSEfidt3aDfmBeg=";
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
    pyjwt
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

  meta = with lib; {
    description = "Python client for the Volkswagen WeConnect Services";
    homepage = "https://github.com/tillsteinbach/WeConnect-python";
    changelog = "https://github.com/tillsteinbach/WeConnect-python/releases/tag/${src.tag}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
