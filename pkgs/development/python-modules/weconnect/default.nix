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
  version = "0.47.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "tillsteinbach";
    repo = "WeConnect-python";
    rev = "refs/tags/v${version}";
    hash = "sha256-qxE8hX6HBmP6s+NivwSgbrPWzUDr8RW9HAyQ21WTiZE=";
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
    substituteInPlace image_extra_requirements.txt \
      --replace "pillow~=9.2.0" "pillow"
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
