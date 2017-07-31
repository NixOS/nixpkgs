{ buildPythonPackage
, fetchPypi
, mock
, zope_testing
, stdenv
}:

buildPythonPackage rec {
  pname = "zc.lockfile";
  version = "1.2.1";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "11db91ada7f22fe8aae268d4bfdeae012c4fe655f66bbb315b00822ec00d043e";
  };

  buildInputs = [ mock ];
  propagatedBuildInputs = [ zope_testing ];

  meta = with stdenv.lib; {
    description = "Inter-process locks";
    homepage =  http://www.python.org/pypi/zc.lockfile;
    license = licenses.zpt20;
    maintainers = with maintainers; [ goibhniu ];
  };
}
