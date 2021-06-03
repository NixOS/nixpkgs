{ lib
, fetchFromGitHub
, buildPythonPackage
, simplejson
, requests
, pythonOlder
}:

buildPythonPackage rec {
  pname = "wallbox";
  version = "0.4.4";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "cliviu74";
    repo = pname;
    rev = version;
    sha256 = "1bj0aiszrszfrv897bhp9s7rdbjz2qqp881gc5yvzvwlmf903rvx";
  };

  propagatedBuildInputs = [
    requests
    simplejson
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "wallbox" ];

  meta = with lib; {
    description = "Python Module interface for Wallbox EV chargers API";
    homepage = "https://github.com/cliviu74/wallbox";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
