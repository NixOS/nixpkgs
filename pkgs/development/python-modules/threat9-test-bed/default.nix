{
  lib,
  buildPythonPackage,
  click,
  faker,
  fetchFromGitHub,
  fetchpatch,
  flask,
  gunicorn,
  pyopenssl,
  pytestCheckHook,
  pythonAtLeast,
  requests,
  setuptools-scm,
  standard-telnetlib,
}:

buildPythonPackage rec {
  pname = "threat9-test-bed";
  version = "0.6.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "threat9";
    repo = "threat9-test-bed";
    rev = "v${version}";
    hash = "sha256-0YSjMf2gDdrvkDaT77iwfCkiDDXKHnZyI8d7JmBSuCg=";
  };

  patches = [
    ./asyncio-loop.patch
    # https://github.com/threat9/threat9-test-bed/pull/25/
    (fetchpatch {
      name = "fix_write_to.patch";
      url = "https://github.com/threat9/threat9-test-bed/commit/6dc75f0c1e42c69e3f948e16476803f9277454ea.patch";
      hash = "sha256-g3XBWbDbwqajTgZjDe0CiSmYovbh5+JM/W2hLdpUvKM=";
    })
  ];

  build-system = [ setuptools-scm ];

  dependencies = [
    click
    faker
    flask
    gunicorn
    pyopenssl
    requests
  ]
  ++ lib.optionals (pythonAtLeast "3.13") [ standard-telnetlib ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "threat9_test_bed" ];

  disabledTests = [
    # Assertion issue with the response codes
    "test_http_service_mock"
    "tests_http_service_mock"
    "test_http_service_mock_random_port"
  ];

  meta = {
    description = "Module for adding unittests.mock as view functions";
    homepage = "https://github.com/threat9/threat9-test-bed";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "test-bed";
  };
}
