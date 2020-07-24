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
  version = "0.10.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "76db248b24cbd6c51cf93b475d8a8df04ec4b6c6287dca244e47f37a433276d7";
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
