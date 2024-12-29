{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  aiohttp,
  pytz,
}:

buildPythonPackage rec {
  pname = "stookwijzer";
  version = "1.5.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "fwestenberg";
    repo = "stookwijzer";
    rev = "refs/tags/v${version}";
    hash = "sha256-QZyuzOAz/VAThgZdhOGeOLvC+2wtp1mgCXzIekBm/Xs=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    pytz
  ];

  pythonImportsCheck = [ "stookwijzer" ];

  # upstream has no tests
  doCheck = false;

  meta = {
    changelog = "https://github.com/fwestenberg/stookwijzer/releases/tag/v${version}";
    description = "Python package for the Stookwijzer API";
    homepage = "https://github.com/fwestenberg/stookwijzer";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
