{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  selenium-manager,
  setuptools,
  certifi,
  pytestCheckHook,
  pythonOlder,
  trio,
  trio-websocket,
  typing-extensions,
  websocket-client,
  urllib3,
  pytest-trio,
  nixosTests,
  stdenv,
  python,
}:

buildPythonPackage rec {
  pname = "selenium";
  version = "4.29.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "SeleniumHQ";
    repo = "selenium";
    tag = "selenium-${version}" + lib.optionalString (lib.versions.patch version != "0") "-python";
    hash = "sha256-IyMXgYl/TPTpe/Y0pFyJVKj4Mp0xbkg1LSCNHzFL3bE=";
  };

  patches = [ ./dont-build-the-selenium-manager.patch ];

  preConfigure = ''
    cd py
  '';

  postInstall = ''
    DST_PREFIX=$out/${python.sitePackages}/selenium/webdriver/
    DST_REMOTE=$DST_PREFIX/remote/
    DST_FF=$DST_PREFIX/firefox
    cp ../rb/lib/selenium/webdriver/atoms/getAttribute.js $DST_REMOTE
    cp ../rb/lib/selenium/webdriver/atoms/isDisplayed.js $DST_REMOTE
    cp ../rb/lib/selenium/webdriver/atoms/findElements.js $DST_REMOTE
    cp ../javascript/cdp-support/mutation-listener.js $DST_REMOTE
    cp ../third_party/js/selenium/webdriver.json $DST_FF/webdriver_prefs.json
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    mkdir -p $DST_PREFIX/common/macos
    ln -s ${lib.getExe selenium-manager} $DST_PREFIX/common/macos/
  ''
  + lib.optionalString stdenv.hostPlatform.isLinux ''
    mkdir -p $DST_PREFIX/common/linux/
    ln -s ${lib.getExe selenium-manager} $DST_PREFIX/common/linux/
  '';

  build-system = [ setuptools ];

  dependencies = [
    certifi
    trio
    trio-websocket
    urllib3
    typing-extensions
    websocket-client
  ]
  ++ urllib3.optional-dependencies.socks;

  nativeCheckInputs = [
    pytestCheckHook
    pytest-trio
  ];

  __darwinAllowLocalNetworking = true;

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
