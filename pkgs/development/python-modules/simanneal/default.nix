{ lib, fetchPypi, buildPythonPackage }:

buildPythonPackage rec {
  pname = "simanneal";
  version = "0.4.1";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1ib1hv2adq6x25z13nb4s1asci6dqarpyhpdq144y2rqqff2m01x";
  };

  meta = {
    description = "A python implementation of the simulated annealing optimization technique";
    homepage = https://github.com/perrygeo/simanneal;
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ veprbl ];
  };
}
