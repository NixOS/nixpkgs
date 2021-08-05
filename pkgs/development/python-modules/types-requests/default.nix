{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "types-requests";
  version = "2.25.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0vyr1vgg03a1gkjcz59iwqc1q9mx4ij7slslsp08z2h8fbhlwl9d";
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
