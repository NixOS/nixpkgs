{ lib
, buildPythonPackage
, fetchFromGitHub
, gevent
, pytestCheckHook
, watchdog
}:

buildPythonPackage rec {
  pname = "watchdog-gevent";
  version = "0.1.1";
  format = "setuptools";

  # Need to fetch from github because tests are not present in pypi
  src = fetchFromGitHub {
    owner = "Bogdanp";
    repo = "watchdog_gevent";
    rev = "v${version}";
    hash = "sha256-FESm3fNuLmOg2ilI/x8U9LuAimHLnahcTHYzW/nzOVY=";
  };

  propagatedBuildInputs = [ watchdog gevent ];

  postPatch = ''
    sed -i setup.cfg \
      -e 's:--cov watchdog_gevent::' \
      -e 's:--cov-report html::'
  '';

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "watchdog_gevent" ];

  meta = with lib; {
    description = "A gevent-based observer for watchdog";
    homepage = "https://github.com/Bogdanp/watchdog_gevent";
    license = licenses.asl20;
    maintainers = with maintainers; [ traxys ];
  };
}
