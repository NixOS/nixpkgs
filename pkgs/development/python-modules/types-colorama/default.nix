{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "types-colorama";
  version = "0.4.15";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-/RKLHjLz/s7F8J30Nm0hSY7obqMfz4tOjxrebQu/mDI=";
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
