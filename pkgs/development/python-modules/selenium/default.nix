{ lib
, fetchFromGitHub
, buildPythonPackage
, python
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
  version = "4.3.0";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "SeleniumHQ";
    repo = "selenium";
    rev = "refs/tags/selenium-${version}"; # check if there is a newer tag with -python suffix
    sha256 = "sha256-tD2sJGVBwqB0uOM3zwdNn71+ILYEHPAvWHvoJN24w6E=";
  };

  postPatch = ''
    substituteInPlace py/selenium/webdriver/firefox/service.py \
      --replace 'DEFAULT_EXECUTABLE_PATH = "geckodriver"' 'DEFAULT_EXECUTABLE_PATH = "${geckodriver}/bin/geckodriver"'
  '';

  preConfigure = ''
    cd py
  '';

  postInstall = ''
    install -Dm 755 ../rb/lib/selenium/webdriver/atoms/getAttribute.js $out/${python.sitePackages}/selenium/webdriver/remote/getAttribute.js
    install -Dm 755 ../rb/lib/selenium/webdriver/atoms/isDisplayed.js $out/${python.sitePackages}/selenium/webdriver/remote/isDisplayed.js
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
