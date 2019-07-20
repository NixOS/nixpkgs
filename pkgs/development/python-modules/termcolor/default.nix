{ stdenv
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "termcolor";
  version = "1.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1d6d69ce66211143803fbc56652b41d73b4a400a2891d7bf7a1cdf4c02de613b";
  };

  meta = with stdenv.lib; {
    description = "Termcolor";
    homepage = https://pypi.python.org/pypi/termcolor;
    license = licenses.mit;
  };

}
