{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hypothesis,
  pytest-twisted,
  pytestCheckHook,
  scrapy,
  setuptools,
  six,
}:

buildPythonPackage rec {
  pname = "scrapy-splash";
  version = "0.11.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "scrapy-plugins";
    repo = "scrapy-splash";
    tag = version;
    hash = "sha256-eOWqSCuuZtUtaEuAew4g0P67N0zClaguHn2u4ZMT3FU=";
  };

  build-system = [ setuptools ];

  dependencies = [
    scrapy
    six
  ];

  pythonImportsCheck = [ "scrapy_splash" ];

  nativeCheckInputs = [
    hypothesis
    pytest-twisted
    pytestCheckHook
  ];

  meta = {
    changelog = "https://github.com/scrapy-plugins/scrapy-splash/blob/${src.tag}/CHANGES.rst";
    description = "Scrapy+Splash for JavaScript integration";
    homepage = "https://github.com/scrapy-plugins/scrapy-splash";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ evanjs ];
  };
}
