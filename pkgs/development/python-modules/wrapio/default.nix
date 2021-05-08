{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "wrapio";
  version = "1.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-JWcPsqZy1wM6/mbU3H0W3EkpLg0wrEUUg3pT/QrL+rE=";
  };

  doCheck = false;
  pythonImportsCheck = [ "wrapio" ];

  meta = with lib; {
    homepage = "https://github.com/Exahilosys/wrapio";
    description = "Handling event-based streams";
    license = licenses.mit;
    maintainers = with maintainers; [ sfrijters ];
  };
}
