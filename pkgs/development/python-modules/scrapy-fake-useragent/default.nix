<<<<<<< HEAD
{ lib
, buildPythonPackage
, fake-useragent
, faker
, fetchFromGitHub
, pytest-mock
, pytestCheckHook
, pythonOlder
, scrapy
}:
=======
{ lib, fetchFromGitHub, buildPythonPackage, pytestCheckHook, pytest-cov, pytest-mock, fake-useragent, faker, scrapy }:
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

buildPythonPackage rec {
  pname = "scrapy-fake-useragent";
  version = "1.4.4";
<<<<<<< HEAD
  format = "setuptools";

  disabled = pythonOlder "3.7";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  # PyPi tarball is corrupted
  src = fetchFromGitHub {
    owner = "alecxe";
    repo = pname;
    rev = "59c20d38c58c76618164760d546aa5b989a79b8b"; # no tags
<<<<<<< HEAD
    hash = "sha256-khQMOQrrdHokvNqfaMWqXV7AzwGxTuxaLsZoLkNpZ3k=";
  };

  postPatch = ''
    substituteInPlace pytest.ini \
      --replace " --cov=scrapy_fake_useragent --cov-report=term --cov-report=html --fulltrace" ""
  '';

  propagatedBuildInputs = [
    fake-useragent
    faker
  ];

  nativeCheckInputs = [
    pytest-mock
    pytestCheckHook
    scrapy
  ];

  pythonImportsCheck = [
    "scrapy_fake_useragent"
  ];

  disabledTests = [
    # AttributeError: 'RetryUserAgentMiddleware' object has no attribute 'EXCEPTIONS_TO_RETRY'
    "test_random_ua_set_on_exception"
  ];
=======
    sha256 = "0yb7d51jws665rdfqkmi077w0pjxmb2ni7ysphj7lx7b18whq54j";
  };

  propagatedBuildInputs = [ fake-useragent faker ];

  nativeCheckInputs = [ pytestCheckHook scrapy pytest-cov pytest-mock ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "Random User-Agent middleware based on fake-useragent";
    homepage = "https://github.com/alecxe/scrapy-fake-useragent";
<<<<<<< HEAD
    changelog = "https://github.com/alecxe/scrapy-fake-useragent/blob/master/CHANGELOG.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
=======
    license = licenses.mit;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
