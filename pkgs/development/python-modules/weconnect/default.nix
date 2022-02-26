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
  version = "0.37.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "tillsteinbach";
    repo = "WeConnect-python";
    rev = "v${version}";
    sha256 = "sha256-h6jKtQt9vCh5bnhIqWLniUIJ41GxCs0uSi4vBVNs8tE=";
  };

  propagatedBuildInputs = [
    ascii-magic
    oauthlib
    pillow
    requests
  ];

  checkInputs = [
    pytest-httpserver
    pytestCheckHook
  ];

  postPatch = ''
    substituteInPlace weconnect/__version.py \
      --replace "develop" "${version}"
    substituteInPlace setup.py \
      --replace "setup_requires=SETUP_REQUIRED," "setup_requires=[]," \
      --replace "tests_require=TEST_REQUIRED," "tests_require=[],"
    substituteInPlace requirements.txt \
      --replace "pillow~=9.0.0" "pillow"
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
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
