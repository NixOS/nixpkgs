{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, selenium
, requests
, websockets
}:

buildPythonPackage {
  pname = "undetected-chromedriver";
  version = "3.5.4";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "ultrafunkamsterdam";
    repo = "undetected-chromedriver";
    rev = "783b8393157b578e19e85b04d300fe06efeef653";
    hash = "sha256-vQ66TAImX0GZCSIaphEfE9O/wMNflGuGB54+29FiUJE=";
  };

  disabled = pythonOlder "3.7";

  propagatedBuildInputs = [
    selenium
    requests
    websockets
  ];

  pythonImportsCheck = [
    "undetected_chromedriver"
  ];

  meta = with lib; {
    homepage = "https://github.com/UltrafunkAmsterdam/undetected-chromedriver";
    changelog = "https://github.com/ultrafunkamsterdam/undetected-chromedriver/blob/master/README.md";
    license = licenses.gpl3Only;
    description = ''
      Selenium.webdriver.Chrome replacement with compatiblity for Brave, and other Chromium based browsers.
    '';
    # undetected-chromedriver will attempt to install a compatible chromedriver binary
    # when undetected-chromedriver.Chrome is instantiated if one is not found in
    # $PATH or passed explicitly as an argument to the constructor
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    maintainers = with maintainers; [ liammurphy14 ];
  };
}
