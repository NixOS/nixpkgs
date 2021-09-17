{ lib
, buildPythonPackage
, isPy27
, fetchPypi
, requests
}:

buildPythonPackage rec {
  pname = "ytmusicapi";
  version = "0.19.1";

  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "1b8a050e2208b3d05359106d8c44c3d62e60edf6753529bd8a207788a6caeb95";
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
