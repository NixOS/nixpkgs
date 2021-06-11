{ lib
, buildPythonPackage
, isPy27
, fetchPypi
, requests
}:

buildPythonPackage rec {
  pname = "ytmusicapi";
  version = "0.17.3";

  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-miScxT79ZAgDT0AamkN1JyqbM56Otk86LnE6HM0G1Vs=";
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
