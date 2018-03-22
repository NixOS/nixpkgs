{ stdenv, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  name = "${pname}-${version}";
  pname = "vcversioner";
  version = "2.16.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "16z10sm78jd7ca3jbkgc3q5i8a8q7y1h21q1li21yy3rlhbhrrns";
  };

  meta = with stdenv.lib; {
    description = "take version numbers from version control";
    homepage = https://github.com/habnabit/vcversioner;
    license = licenses.isc;
  };
}
