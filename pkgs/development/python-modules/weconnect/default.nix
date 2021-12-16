{ lib
, ascii-magic
, buildPythonPackage
, fetchFromGitHub
, pillow
, pytest-httpserver
, pytestCheckHook
, pythonOlder
, requests
}:

buildPythonPackage rec {
  pname = "weconnect";
  version = "0.27.2";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "tillsteinbach";
    repo = "WeConnect-python";
    rev = "v${version}";
    sha256 = "1834px1r301sndfzxsyl8qd00phdrr29qkg98nvf3gi0rhd80ps7";
  };

  propagatedBuildInputs = [
    ascii-magic
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
