{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "types-colorama";
  version = "0.4.15.20240205";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-euT1jUB9OH9PmLJNgeG3ZX7HVOodxGGa5b0n8MNnY34=";
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
