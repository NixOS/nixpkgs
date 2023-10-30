{ lib
, fetchFromGitHub
, fetchpatch
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
  version = "4.12.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "SeleniumHQ";
    repo = "selenium";
    # check if there is a newer tag with or without -python suffix
    rev = "refs/tags/selenium-${version}";
    hash = "sha256-A2lI40bPSIri/0yp6C3aJZBX5p6ON1fWGfJTcul9/2o=";
  };

  patches = [
    (fetchpatch {
      # Fix CONDA_PREFIX access test; https://github.com/SeleniumHQ/selenium/pull/13071
      url = "https://github.com/SeleniumHQ/selenium/commit/c158a799eae8d1838abfed08532d7fef6612564c.patch";
      hash = "sha256-lkKSxDKKXVUvDjUhvacH2n5+65mFbkEIt5+yuRbAo4o=";
    })
  ];

  postPatch = ''
    substituteInPlace py/selenium/webdriver/firefox/service.py \
      --replace 'executable_path: str = None,' 'executable_path="${geckodriver}/bin/geckodriver",'
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
    maintainers = with maintainers; [ jraygauthier ];
  };
}
