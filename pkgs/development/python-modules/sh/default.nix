{ stdenv
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "sh";
  version = "1.11";

  src = fetchPypi {
    inherit pname version;
    sha256 = "590fb9b84abf8b1f560df92d73d87965f1e85c6b8330f8a5f6b336b36f0559a4";
  };

  doCheck = false;

  meta = with stdenv.lib; {
    description = "Python subprocess interface";
    homepage = https://pypi.python.org/pypi/sh/;
    license = licenses.mit;
  };

}
