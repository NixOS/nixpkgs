{ stdenv
, buildPythonPackage
, fetchPypi
, requests
, six
}:

buildPythonPackage rec {
  version = "0.3.3";
  pname = "vmprof";

  src = fetchPypi {
    inherit pname version;
    sha256 = "991bc2f1dc824c63e9b399f9e8606deded92a52378d0e449f258807d7556b039";
  };

  propagatedBuildInputs = [ requests six];

  # No tests included
  doCheck = false;

  meta = with stdenv.lib; {
    description = "A vmprof client";
    license = licenses.mit;
    homepage = https://vmprof.readthedocs.org/;
  };

}
