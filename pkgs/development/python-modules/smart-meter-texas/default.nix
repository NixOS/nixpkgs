{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, aiohttp
, python-dateutil
, tenacity
}:

buildPythonPackage rec {
  pname = "smart-meter-texas";
  version = "0.4.4";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "grahamwetzler";
    repo = "smart-meter-texas";
    rev = "v${version}";
    sha256 = "sha256-jewibcsqWnl0OQ2oEEOSOcyyDCIGZiG4EZQfuFUbxK4=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "pytest-runner" ""
  '';

  propagatedBuildInputs = [
    aiohttp
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
