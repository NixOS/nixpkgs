{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "types-colorama";
  version = "0.4.15.20240310";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-fr/clzbTk8+7G/5g1Q4kbnAggxC2WaZS8eV35YDWvs8=";
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
