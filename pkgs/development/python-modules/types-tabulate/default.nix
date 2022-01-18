{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "types-tabulate";
  version = "0.8.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-A/KDvzhOoSG3tqWK+zj03vl/MHBPyhOg2mhpNrDzkqw=";
  };

  # Module doesn't have tests
  doCheck = false;

  meta = with lib; {
    description = "Typing stubs for tabulate";
    homepage = "https://github.com/python/typeshed";
    license = licenses.asl20;
    maintainers = with maintainers; [ jpetrucciani ];
  };
}
