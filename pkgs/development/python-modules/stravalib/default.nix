{ lib
, buildPythonPackage
, fetchPypi
, nose
, arrow
, requests
, units
, pytz
, six
}:

buildPythonPackage rec {
  pname = "stravalib";
  version = "1.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-qn46u1Kq2fkEL/JnjDNKbJZMTz/pitveNFPaf2xkbYs=";
  };

  checkInputs = [
    nose
  ];

  propagatedBuildInputs = [
    arrow
    requests
    units
    pytz
    six
  ];

  # tests require network access
  # testing strava api
  doCheck = false;

  meta = with lib; {
    description = "Python library for interacting with Strava v3 REST API";
    homepage = "https://github.com/hozn/stravalib";
    license = licenses.asl20;
    maintainers = [ maintainers.costrouc ];
  };
}
