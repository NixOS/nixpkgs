{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  aiohttp,
  asn1_2,
  python-dateutil,
  setuptools,
  tenacity,
}:

buildPythonPackage rec {
  pname = "smart-meter-texas";
  version = "0.5.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "grahamwetzler";
    repo = "smart-meter-texas";
    tag = "v${version}";
    hash = "sha256-dHWcYrBtmKdEIU45rMy4KvoPX88hnRpd4KBlbJaNvgI=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail "pytest-runner" ""
  '';

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    # _find_ca_issuers_uri() recurses with enter()/leave() and loops on eof(),
    # which is only container-relative in asn1 2.x
    asn1_2
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
