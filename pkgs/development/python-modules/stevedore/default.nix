{ stdenv, buildPythonPackage, fetchPypi, pbr, six }:

buildPythonPackage rec {
  pname = "stevedore";
  version = "1.30.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0161pwgv6514ks6lky8642phlcqks5w8j5sacdnbfgx5s6nwfaxr";
  };

  doCheck = false;

  propagatedBuildInputs = [ pbr six ];

  meta = with stdenv.lib; {
    description = "Manage dynamic plugins for Python applications";
    homepage = https://pypi.python.org/pypi/stevedore;
    license = licenses.asl20;
  };
}
