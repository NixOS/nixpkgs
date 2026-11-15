{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  aiohttp,
  asn1,
  certifi,
  python-dateutil,
  setuptools,
  tenacity,
}:

buildPythonPackage rec {
  pname = "smart-meter-texas";
  version = "0.6.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "grahamwetzler";
    repo = "smart-meter-texas";
    tag = "v${version}";
    hash = "sha256-g0AqbI3YZaHw5oHj6QjlpiAS/jbA9ZbbCAvDrzSwb9c=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail "pytest-runner" ""
  '';

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    asn1
    certifi
    python-dateutil
    tenacity
  ];

  # no tests implemented
  doCheck = false;

  meta = {
    description = "Connect to and retrieve data from the unofficial Smart Meter Texas API";
    homepage = "https://github.com/grahamwetzler/smart-meter-texas";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
