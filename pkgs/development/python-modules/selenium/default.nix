{ lib
, fetchFromGitHub
, buildPythonPackage
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
  version = "4.4.2";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "SeleniumHQ";
    repo = "selenium";
    rev = "refs/tags/selenium-${version}-python"; # check if there is a newer tag with -python suffix
    hash = "sha256-sJJ3i4mnGp5fDgo64p6B2vRCqp/Wm99VoyRLyy4nBH8=";
  };

  postPatch = ''
    substituteInPlace py/selenium/webdriver/firefox/service.py \
      --replace 'DEFAULT_EXECUTABLE_PATH = "geckodriver"' 'DEFAULT_EXECUTABLE_PATH = "${geckodriver}/bin/geckodriver"'
  '';

  preConfigure = ''
    cd py
  '';

  propagatedBuildInputs = [
    trio
    trio-websocket
    urllib3
  ] ++ urllib3.optional-dependencies.secure
  ++ urllib3.optional-dependencies.socks;

  checkInputs = [
    pytestCheckHook
  ];

  passthru.tests = {
    testing-vaultwarden = nixosTests.vaultwarden;
  };

  meta = with lib; {
    description = "Bindings for Selenium WebDriver";
    homepage = "https://selenium.dev/";
    license = licenses.asl20;
    maintainers = with maintainers; [ jraygauthier ];
  };
}
