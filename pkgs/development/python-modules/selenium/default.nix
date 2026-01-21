{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  selenium-manager,
  setuptools,
  certifi,
  pytestCheckHook,
  trio,
  trio-typing,
  trio-websocket,
  typing-extensions,
  websocket-client,
  urllib3,
  filetype,
  pytest-mock,
  pytest-trio,
  rich,
  nixosTests,
  stdenv,
  python,
}:

buildPythonPackage rec {
  pname = "selenium";
  version = "4.40.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "SeleniumHQ";
    repo = "selenium";
    tag = "selenium-${version}" + lib.optionalString (lib.versions.patch version != "0") "-python";
    hash = "sha256-Yfm2kpAmmEUP+m48PQf09UvFPeGBxd0ukqTtVah5h+E=";
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

    find $out/${python.sitePackages}/
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
    trio-typing
    trio-websocket
    typing-extensions
    urllib3
    websocket-client
  ]
  ++ urllib3.optional-dependencies.socks;

  pythonRemoveDeps = [
    "types-certifi"
    "types-urllib3"
  ];

  nativeCheckInputs = [
    filetype
    pytestCheckHook
    pytest-mock
    pytest-trio
    rich
  ];

  disabledTestPaths = [
    # ERROR without error context
    "test/selenium/webdriver/common/bidi_webextension_tests.py"
    "test/selenium/webdriver/firefox/ff_installs_addons_tests.py"
    # Fails to find browsers during test phase
    "test/selenium"
  ];

  disabledTests = [
    # Fails to find data that is only copied into out in postInstall
    "test_missing_cdp_devtools_version_falls_back"
    "test_uses_windows"
    "test_uses_linux"
    "test_uses_mac"
    "test_set_profile_with_firefox_profile"
    "test_set_profile_with_path"
    "test_creates_capabilities"
    "test_get_connection_manager_for_certs_and_timeout"
  ];

  __darwinAllowLocalNetworking = true;

  passthru.tests = {
    testing-vaultwarden = nixosTests.vaultwarden;
  };

  meta = {
    description = "Bindings for Selenium WebDriver";
    homepage = "https://selenium.dev/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ jraygauthier ];
  };
}
