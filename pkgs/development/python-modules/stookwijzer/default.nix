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
  version = "1.4.10";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "fwestenberg";
    repo = "stookwijzer";
    rev = "refs/tags/v${version}";
    hash = "sha256-uvmv35rdmqfr+psGQdnb3g2q72qCx4ew3gJdGeun6W8=";
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
