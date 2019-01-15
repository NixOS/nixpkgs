{ stdenv
, buildPythonPackage
, fetchPypi
, requests
, six
}:

buildPythonPackage rec {
  version = "0.4.12";
  pname = "vmprof";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d6fa566512de1e17c9b585feae6e6997119e0d43c41c8461a9a2e8a8276618a4";
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
