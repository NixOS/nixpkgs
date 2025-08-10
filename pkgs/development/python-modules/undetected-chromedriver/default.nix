{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  setuptools,

  looseversion,
  requests,
  selenium,
  websockets,
}:

buildPythonPackage {
  pname = "undetected-chromedriver";
  version = "3.5.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ultrafunkamsterdam";
    repo = "undetected-chromedriver";
    # Upstream uses the summaries of commits for specifying versions
    rev = "0aa5fbe252370b4cb2b95526add445392cad27ba";
    hash = "sha256-Qe+GrsUPnhjJMDgjdUCloapjj0ggFlm/Dr42WLcmb1o=";
  };

  build-system = [ setuptools ];

  dependencies = [
    looseversion
    requests
    selenium
    websockets
  ];

  # No tests
  doCheck = false;

  pythonImportsCheck = [ "undetected_chromedriver" ];

  postPatch = ''
    substituteInPlace undetected_chromedriver/patcher.py \
      --replace-fail \
        "from distutils.version import LooseVersion" \
        "from looseversion import LooseVersion"
  '';

  meta = with lib; {
    description = "Python library for the custom Selenium ChromeDriver that passes all bot mitigation systems";
    homepage = "https://github.com/ultrafunkamsterdam/undetected-chromedriver";
    license = licenses.gpl3Only;
    maintainers = with lib.maintainers; [ ];
  };
}
