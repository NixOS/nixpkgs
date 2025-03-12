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
  version = "1.6.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "fwestenberg";
    repo = "stookwijzer";
    tag = "v${version}";
    hash = "sha256-T4u3KuKWAXRkHbjPt4qkiisnLjx9JMD0DW6enOlu69g=";
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
    changelog = "https://github.com/fwestenberg/stookwijzer/releases/tag/${src.tag}";
    description = "Python package for the Stookwijzer API";
    homepage = "https://github.com/fwestenberg/stookwijzer";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
