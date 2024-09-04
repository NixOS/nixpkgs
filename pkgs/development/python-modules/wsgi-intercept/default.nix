{
  lib,
  buildPythonPackage,
  fetchPypi,
  six,
  httplib2,
  py,
  pytestCheckHook,
  pythonOlder,
  requests,
  setuptools,
  urllib3,
}:

buildPythonPackage rec {
  pname = "wsgi-intercept";
  version = "1.13.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "wsgi_intercept";
    inherit version;
    hash = "sha256-eb1sY5qxH36r5dGK2aIPYu6CocQ1EkqHbP/YA49sJME=";
  };

  build-system = [ setuptools ];

  dependencies = [ six ];

  nativeCheckInputs = [
    httplib2
    py
    pytestCheckHook
    requests
    urllib3
  ];

  disabledTests = [
    # Tests require network access
    "test_urllib3"
    "test_requests"
    "test_http_not_intercepted"
    "test_https_not_intercepted"
    "test_https_no_ssl_verification_not_intercepted"
  ];

  pythonImportsCheck = [ "wsgi_intercept" ];

  meta = with lib; {
    description = "Module that acts as a WSGI application in place of a real URI for testing";
    homepage = "https://github.com/cdent/wsgi-intercept";
    changelog = "https://github.com/cdent/wsgi-intercept/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ mikecm ];
  };
}
