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
  version = "0.4.3";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "grahamwetzler";
    repo = "smart-meter-texas";
    rev = "v${version}";
    sha256 = "09n03wbyjh1b1gsiibf17fg86x7k1i1r1kpp94p7w1lcdbmn8v5c";
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
