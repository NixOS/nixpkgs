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
  version = "1.4.9";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "fwestenberg";
    repo = "stookwijzer";
    rev = "refs/tags/v${version}";
    hash = "sha256-QXCusmbt40Tg73ozl9nIDgMtQJ152uNhOuFyHn+OEA8=";
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
