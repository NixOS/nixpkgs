{ stdenv
, buildPythonPackage
, fetchPypi
, requests
, six
}:

buildPythonPackage rec {
  version = "0.4.13";
  pname = "vmprof";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b6121f3d989fe48c2fb7242acded5f1e2e86d25d05d73c41257f236fd9badb2c";
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
