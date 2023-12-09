{ lib
, fetchPypi
, buildPythonPackage
, cbor
, numpy
}:

buildPythonPackage rec {
  pname = "trec-car-tools";
  version = "2.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-L84t4SAiT9VpsVHVvtNYpO0zTmQ4ibnj3+Plo9FdIcg=";
  };

  propagatedBuildInputs = [
    cbor
    numpy
  ];

  meta = with lib; {
    homepage = "https://github.com/TREMA-UNH/trec-car-tools/python3";
    license = licenses.bsd3;
    description = "Support tools for TREC CAR participants";
    maintainers = [ maintainers.gm6k ];
  };
}
