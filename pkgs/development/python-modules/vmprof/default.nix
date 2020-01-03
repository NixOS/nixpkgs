{ stdenv
, buildPythonPackage
, fetchPypi
, requests
, six
}:

buildPythonPackage rec {
  version = "0.4.15";
  pname = "vmprof";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a2d872a40196404386d1e0d960e97b37c86c3f72a4f9d5a2b5f9ca1adaff5b62";
  };

  propagatedBuildInputs = [ requests six];

  # No tests included
  doCheck = false;

  meta = with stdenv.lib; {
    description = "A vmprof client";
    license = licenses.mit;
    homepage = https://vmprof.readthedocs.org/;
    broken = true;
  };

}
