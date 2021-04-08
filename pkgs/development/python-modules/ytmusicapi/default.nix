{ lib
, buildPythonPackage
, isPy27
, fetchPypi
, requests
}:

buildPythonPackage rec {
  pname = "ytmusicapi";
  version = "0.15.1";

  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-W/eZubJ/SNLBya1S6wLUwTwZCUD+wCQ5FAuNcSpl+9Y=";
  };

  propagatedBuildInputs = [
    requests
  ];

  doCheck = false; # requires network access

  pythonImportsCheck = [ "ytmusicapi" ];

  meta = with lib; {
    description = "Unofficial API for YouTube Music";
    homepage = "https://github.com/sigma67/ytmusicapi";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
