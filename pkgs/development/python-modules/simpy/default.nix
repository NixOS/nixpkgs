{ buildPythonPackage, fetchPypi, lib }:

buildPythonPackage rec {
  pname = "simpy";
  version = "3.0.11";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0hqgxk3lggf21jq9lh8838cdl24mdkdnpzh0w4m28d0zn2wjb5nh";
  };

  meta = with lib; {
    homepage = https://simpy.readthedocs.io/en/latest/;
    description = "A process-based discrete-event simulation framework based on standard Python.";
    license = [ licenses.mit ];
    maintainers = with maintainers; [ shlevy ];
  };
}
