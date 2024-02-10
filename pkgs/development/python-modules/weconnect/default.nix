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
  version = "0.59.5";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "tillsteinbach";
    repo = "WeConnect-python";
    rev = "refs/tags/v${version}";
    hash = "sha256-ujIA98QD8ds2/iLLeJqn88nY9tZuuOSnOwGvRznA8PQ=";
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
    substituteInPlace image_extra_requirements.txt \
      --replace "pillow~=" "pillow>=" \
      --replace "ascii_magic~=" "ascii_magic>="
    substituteInPlace pytest.ini \
      --replace "--cov=weconnect --cov-config=.coveragerc --cov-report html" "" \
      --replace "required_plugins = pytest-httpserver pytest-cov" ""
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
