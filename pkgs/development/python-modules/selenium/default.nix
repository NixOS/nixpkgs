{ lib
, fetchFromGitHub
, buildPythonPackage
, certifi
, geckodriver
, pytestCheckHook
, pythonOlder
, trio
, trio-websocket
, urllib3
, nixosTests
}:

buildPythonPackage rec {
  pname = "selenium";
  version = "4.7.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "SeleniumHQ";
    repo = "selenium";
    # check if there is a newer tag with or without -python suffix
    rev = "refs/tags/selenium-${version}";
    hash = "sha256-7inmi8dHi6So+8AbLq85Go/GEaiV1XK/7+wt9UkTdo8=";
  };

  postPatch = ''
    substituteInPlace py/selenium/webdriver/firefox/service.py \
      --replace 'DEFAULT_EXECUTABLE_PATH = "geckodriver"' 'DEFAULT_EXECUTABLE_PATH = "${geckodriver}/bin/geckodriver"'
  '';

  preConfigure = ''
    cd py
  '';

  propagatedBuildInputs = [
    certifi
    trio
    trio-websocket
    urllib3
  ] ++ urllib3.optional-dependencies.socks;

  nativeCheckInputs = [
    pytestCheckHook
  ];

  passthru.tests = {
    testing-vaultwarden = nixosTests.vaultwarden;
  };

  meta = with lib; {
    description = "Bindings for Selenium WebDriver";
    homepage = "https://selenium.dev/";
    license = licenses.asl20;
    maintainers = with maintainers; [ jraygauthier SuperSandro2000 ];
  };
}
