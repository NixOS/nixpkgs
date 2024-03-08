{ lib
, fetchFromGitHub
, fetchurl
, buildPythonPackage
, certifi
, pytestCheckHook
, pythonOlder
, trio
, trio-websocket
, typing-extensions
, urllib3
, pytest-trio
, nixosTests
, stdenv
, python
}:

let
  # TODO: build these from source, e.g. for aarch64-linux support
  # https://github.com/SeleniumHQ/selenium/blob/selenium-4.18.1/common/selenium_manager.bzl
  selenium-manager = let
    darwin = fetchurl {
      url = "https://github.com/SeleniumHQ/selenium_manager_artifacts/releases/download/selenium-manager-8fab886/selenium-manager-macos";
      sha256 = "43168f3c79747b5dd86a6aeb5fc8fb642614899c4ce427e8dcd57737cf70be7f";
    };
    linux = fetchurl {
      url = "https://github.com/SeleniumHQ/selenium_manager_artifacts/releases/download/selenium-manager-8fab886/selenium-manager-linux";
      sha256 = "ec6db2c8ea49cf4fafaf52e70ffcbcac3d49d07df7ca11dba49652b9d51d2d1a";
    };
  in {
    x86_64-linux = linux;
    aarch64-darwin = darwin;
    x86_64_darwin = darwin;
  }.${stdenv.hostPlatform.system} or (throw "Unsupported architecture: ${stdenv.hostPlatform.system}");
in

buildPythonPackage rec {
  pname = "selenium";
  version = "4.18.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "SeleniumHQ";
    repo = "selenium";
    # check if there is a newer tag with or without -python suffix
    rev = "refs/tags/selenium-${version}";
    hash = "sha256-1C9Epsk9rFlShxHGGzbWl6smrMzPn2h3yCWlzUIMpY8=";
  };

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
  '' + lib.optionalString stdenv.isDarwin ''
    mkdir -p $DST_PREFIX/common/macos
    cp ${selenium-manager} $DST_PREFIX/common/macos
  '' + lib.optionalString stdenv.isLinux ''
    mkdir -p $DST_PREFIX/common/linux/
    cp ${selenium-manager} $DST_PREFIX/common/linux/
  '';

  propagatedBuildInputs = [
    certifi
    trio
    trio-websocket
    urllib3
    typing-extensions
  ] ++ urllib3.optional-dependencies.socks;

  nativeCheckInputs = [
    pytestCheckHook
    pytest-trio
  ];

  passthru.tests = {
    testing-vaultwarden = nixosTests.vaultwarden;
  };

  meta = with lib; {
    broken = stdenv.isAarch64 && stdenv.isLinux; # no supported manager binary
    description = "Bindings for Selenium WebDriver";
    homepage = "https://selenium.dev/";
    license = licenses.asl20;
    maintainers = with maintainers; [ jraygauthier ];
  };
}
