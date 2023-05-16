{ lib
, ascii-magic
, buildPythonPackage
, fetchFromGitHub
, pillow
, pytest-httpserver
, pytestCheckHook
, pythonOlder
, requests
, oauthlib
}:

buildPythonPackage rec {
  pname = "weconnect";
<<<<<<< HEAD
  version = "0.58.0";
=======
  version = "0.54.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "tillsteinbach";
    repo = "WeConnect-python";
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-2+RvDAKIUsQwmVrqcgt0RXOF+Z+lZ6oSyZyI+HTcZBs=";
=======
    hash = "sha256-Zjh4rWnpzzBZFQRZIoceeIn4DYn0/HqLLZFhc57yhLQ=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    oauthlib
    requests
  ];

  passthru.optional-dependencies = {
    Images = [
      ascii-magic
      pillow
    ];
  };

  nativeCheckInputs = [
    pytest-httpserver
    pytestCheckHook
  ];

  postPatch = ''
    substituteInPlace weconnect/__version.py \
      --replace "develop" "${version}"
    substituteInPlace setup.py \
      --replace "setup_requires=SETUP_REQUIRED," "setup_requires=[]," \
      --replace "tests_require=TEST_REQUIRED," "tests_require=[],"
<<<<<<< HEAD
    substituteInPlace requirements.txt \
      --replace "requests~=2.29.0" "requests"
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    substituteInPlace image_extra_requirements.txt \
      --replace "pillow~=" "pillow>=" \
      --replace "ascii_magic~=" "ascii_magic>="
    substituteInPlace pytest.ini \
      --replace "--cov=weconnect --cov-config=.coveragerc --cov-report html" "" \
      --replace "pytest-cov" ""
  '';

  pythonImportsCheck = [
    "weconnect"
  ];

  meta = with lib; {
    description = "Python client for the Volkswagen WeConnect Services";
    homepage = "https://github.com/tillsteinbach/WeConnect-python";
    changelog = "https://github.com/tillsteinbach/WeConnect-python/releases/tag/v${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
