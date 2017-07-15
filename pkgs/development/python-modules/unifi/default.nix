{
stdenv, lib, buildPythonPackage, fetchPypi,
urllib3
}:

buildPythonPackage rec {
  pname = "unifi";
  version = "1.2.5";
  name = "${pname}-${version}";

  propagatedBuildInputs = [ urllib3 ];

  # upstream has no tests
  doCheck = false;

  meta = {
    description = "An API towards the Ubiquity Networks UniFi controller";
    homepage    = https://pypi.python.org/pypi/unifi/;
    license     = lib.licenses.mit;
    maintainers = with lib.maintainers; [ peterhoeg ];
  };

  src = fetchPypi {
    inherit pname version;
    sha256 = "0prgx01hzs49prrazgxrinm7ivqzy57ch06qm2h7s1p957sazds8";
  };
}
