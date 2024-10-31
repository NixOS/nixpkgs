{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  aiohttp,
  asn1,
  python-dateutil,
  setuptools,
  tenacity,
}:

buildPythonPackage rec {
  pname = "smart-meter-texas";
  version = "0.5.5";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "grahamwetzler";
    repo = "smart-meter-texas";
    rev = "refs/tags/v${version}";
    hash = "sha256-dHWcYrBtmKdEIU45rMy4KvoPX88hnRpd4KBlbJaNvgI=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail "pytest-runner" ""
  '';

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    asn1
    python-dateutil
    tenacity
  ];

  # no tests implemented
  doCheck = false;

  meta = with lib; {
    description = "Connect to and retrieve data from the unofficial Smart Meter Texas API";
    homepage = "https://github.com/grahamwetzler/smart-meter-texas";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
