{ stdenv, fetchPypi, buildPythonPackage, six }:

buildPythonPackage rec {
  pname   = "tld";
  version = "0.9.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0i0prgwrmm157h6fa5bx9wm0m70qq2nhzp743374a94p9s766rpp";
  };

  doCheck = false;
  propagatedBuildInputs = [ six ];

  meta = with stdenv.lib; {
    homepage = https://github.com/barseghyanartur/tld;
    description = "Extracts the top level domain (TLD) from the URL given";
    license = licenses.lgpl21;
    maintainers = with maintainers; [ genesis ];
  };

}
