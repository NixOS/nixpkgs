{ lib
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
  version = "1.2.1";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "allisson";
    repo = "python-simple-rest-client";
    rev = version;
    hash = "sha256-IaLo7nBMIabi4ZjZ4ZLJliCL/dzidaCBCmn0cq7Fzdw=";
  };

  propagatedBuildInputs = [
    httpx
    python-slugify
    python-status
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytest-httpserver
    pytestCheckHook
  ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace "pytest-runner" ""
    substituteInPlace pytest.ini \
      --replace " --cov=simple_rest_client --cov-report=term-missing" ""
    substituteInPlace requirements-dev.txt \
      --replace "asyncmock" ""
  '';

  disabledTestPaths = [
    "tests/test_decorators.py"
  ];

  pythonImportsCheck = [
    "simple_rest_client"
  ];

  meta = with lib; {
    description = "Simple REST client for Python";
    homepage = "https://github.com/allisson/python-simple-rest-client";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
