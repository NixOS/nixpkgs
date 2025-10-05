{
  lib,
  buildPythonPackage,
  setuptools,
  fake-useragent,
  faker,
  fetchFromGitHub,
  pytest-cov-stub,
  pytest-mock,
  pytestCheckHook,
  pythonOlder,
  scrapy,
}:

buildPythonPackage {
  pname = "scrapy-fake-useragent";
  version = "1.4.4";
  pyproject = true;

  disabled = pythonOlder "3.7";

  # PyPi tarball is corrupted
  src = fetchFromGitHub {
    owner = "alecxe";
    repo = "scrapy-fake-useragent";
    rev = "59c20d38c58c76618164760d546aa5b989a79b8b"; # no tags
    hash = "sha256-khQMOQrrdHokvNqfaMWqXV7AzwGxTuxaLsZoLkNpZ3k=";
  };

  postPatch = ''
    substituteInPlace pytest.ini \
      --replace-fail " --fulltrace" ""
  '';

  build-system = [ setuptools ];

  dependencies = [
    fake-useragent
    faker
  ];

  nativeCheckInputs = [
    pytest-cov-stub
    pytest-mock
    pytestCheckHook
    scrapy
  ];

  pythonImportsCheck = [ "scrapy_fake_useragent" ];

  disabledTests = [
    # AttributeError: 'RetryUserAgentMiddleware' object has no attribute 'EXCEPTIONS_TO_RETRY'
    "test_random_ua_set_on_exception"
  ];

  meta = with lib; {
    description = "Random User-Agent middleware based on fake-useragent";
    homepage = "https://github.com/alecxe/scrapy-fake-useragent";
    changelog = "https://github.com/alecxe/scrapy-fake-useragent/blob/master/CHANGELOG.rst";
    license = licenses.mit;
    maintainers = [ ];
  };
}
