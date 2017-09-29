{ stdenv, buildPythonPackage
, fetchPypi, urllib3 }:

buildPythonPackage rec {
  pname = "unifi";
  version = "1.2.5";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0prgx01hzs49prrazgxrinm7ivqzy57ch06qm2h7s1p957sazds8";
  };

  propagatedBuildInputs = [ urllib3 ];

  # upstream has no tests
  doCheck = false;

  meta = with stdenv.lib; {
    description = "An API towards the Ubiquity Networks UniFi controller";
    homepage    = https://pypi.python.org/pypi/unifi/;
    license     = licenses.mit;
    maintainers = with maintainers; [ peterhoeg ];
  };
}
