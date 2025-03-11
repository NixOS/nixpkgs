{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  six,
  httplib2,
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

  src = fetchFromGitHub {
    owner = "cdent";
    repo = "wsgi-intercept";
    tag = "v${version}";
    hash = "sha256-hs5yB0+eDlh/pNPaqYIU9C+RBpyrdPOAscQGIoqzmvU=";
  };

  build-system = [ setuptools ];

  dependencies = [ six ];

  nativeCheckInputs = [
    pytestCheckHook
    httplib2
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

  meta = {
    description = "Module that acts as a WSGI application in place of a real URI for testing";
    homepage = "https://github.com/cdent/wsgi-intercept";
    changelog = "https://github.com/cdent/wsgi-intercept/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ mikecm ];
  };
}
