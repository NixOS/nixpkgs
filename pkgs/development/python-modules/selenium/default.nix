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
, pytest-trio
, nixosTests
, stdenv
, python
}:

buildPythonPackage rec {
  pname = "selenium";
  version = "4.15.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "SeleniumHQ";
    repo = "selenium";
    # check if there is a newer tag with or without -python suffix
    rev = "refs/tags/selenium-${version}";
    hash = "sha256-AacpHZw6N6RruuBO+bZ3/cxOODe9VPGblKmIm1ffqrc=";
  };

  preConfigure = ''
    cd py
  '';

  postInstall = ''
    DST_PREFIX=$out/lib/${python.libPrefix}/site-packages/selenium/webdriver/
    DST_REMOTE=$DST_PREFIX/remote/
    DST_FF=$DST_PREFIX/firefox
    cp ../rb/lib/selenium/webdriver/atoms/getAttribute.js $DST_REMOTE
    cp ../rb/lib/selenium/webdriver/atoms/isDisplayed.js $DST_REMOTE
    cp ../rb/lib/selenium/webdriver/atoms/findElements.js $DST_REMOTE
    cp ../javascript/cdp-support/mutation-listener.js $DST_REMOTE
    cp ../third_party/js/selenium/webdriver.json $DST_FF/webdriver_prefs.json
  '' + lib.optionalString stdenv.isDarwin ''
    mkdir -p $DST_PREFIX/common/macos
    cp ../common/manager/macos/selenium-manager $DST_PREFIX/common/macos
  '' + lib.optionalString stdenv.isLinux ''
    mkdir -p $DST_PREFIX/common/linux/
    cp ../common/manager/linux/selenium-manager $DST_PREFIX/common/linux/
  '';

  propagatedBuildInputs = [
    certifi
    trio
    trio-websocket
    urllib3
  ] ++ urllib3.optional-dependencies.socks;

  nativeCheckInputs = [
    pytestCheckHook
    pytest-trio
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
