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
  version = "0.10.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "451817c68a11e0c77db9cb628e3c4df0f4806c5a481536598ab3baa1d1c21215";
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
