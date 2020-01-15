{ stdenv
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  version = "1.3.0";
  pname = "xxhash";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1rhrqrlq4n3vgqd1fv1dcc5ga5dzy9qbd40p8rsqqhh5klxg48gy";
  };

  meta = with stdenv.lib; {
    homepage = https://github.com/ifduyue/python-xxhash;
    description = "Python Binding for xxHash https://pypi.org/project/xxhash/";
    license = licenses.bsd2;
    maintainers = [ maintainers.teh ];
  };
}
