{ stdenv
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "threadpool";
  version = "1.3.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "197gzrxn9lbk0q1v079814c6s05cr4rwzyl6c1m6inkyif4yzr6c";
  };

  meta = with stdenv.lib; {
    homepage = http://chrisarndt.de/projects/threadpool/;
    description = "Easy to use object-oriented thread pool framework";
    license = licenses.mit;
  };

}
