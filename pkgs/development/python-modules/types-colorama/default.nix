{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "types-colorama";
  version = "0.4.15.4";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-YPfWJXkTE1IYVkzxudLpZ4wM5ywFHZ/6oadMdpBOWAg=";
  };

  # Module has no tests
  doCheck = false;

  meta = with lib; {
    description = "Typing stubs for colorama";
    homepage = "https://github.com/python/typeshed";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
