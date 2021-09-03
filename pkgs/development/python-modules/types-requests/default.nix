{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "types-requests";
  version = "2.25.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1vh203dppi6457lwv7z46dc8rpanjlahk4v3394nq1jwyp0425g2";
  };

  # Modules doesn't have tests
  doCheck = false;

  pythonImportsCheck = [ "requests-stubs" ];

  meta = with lib; {
    description = "Typing stubs for requests";
    homepage = "https://github.com/python/typeshed";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
