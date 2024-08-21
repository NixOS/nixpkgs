{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "vcversioner";
  version = "2.16.0.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "16z10sm78jd7ca3jbkgc3q5i8a8q7y1h21q1li21yy3rlhbhrrns";
  };

  meta = with lib; {
    description = "take version numbers from version control";
    homepage = "https://github.com/habnabit/vcversioner";
    license = licenses.isc;
  };
}
