{ lib
, buildPythonPackage
, isPy27
, fetchPypi
, requests
}:

buildPythonPackage rec {
  pname = "ytmusicapi";
  version = "0.15.0";

  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-pVQqoMvuuFc/1QNG5z/AspGlgIGPi9aqjZ3/3eVNhis=";
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
