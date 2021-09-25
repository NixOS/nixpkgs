{ lib
, asynctest
, buildPythonPackage
, fetchFromGitHub
, httpx
, pytest-asyncio
, pytest-httpserver
, pytestCheckHook
, python-slugify
, python-status
, pythonOlder
}:

buildPythonPackage rec {
  pname = "simple-rest-client";
  version = "1.0.8";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "allisson";
    repo = "python-simple-rest-client";
    rev = version;
    sha256 = "12qxhrjhlbyyr1pkvwfkcxbsmyns5b0mfdn42vz310za5x76ldj3";
  };

  propagatedBuildInputs = [
    httpx
    python-slugify
    python-status
  ];

  checkInputs = [
    asynctest
    pytest-asyncio
    pytest-httpserver
    pytestCheckHook
  ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace "pytest-runner" ""
    substituteInPlace pytest.ini \
      --replace " --cov=simple_rest_client --cov-report=term-missing" ""
  '';

  pythonImportsCheck = [ "simple_rest_client" ];

  meta = with lib; {
    description = "Simple REST client for Python";
    homepage = "https://github.com/allisson/python-simple-rest-client";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
