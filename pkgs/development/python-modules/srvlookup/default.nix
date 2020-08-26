{ stdenv, fetchPypi, buildPythonPackage
, dnspython
, mock, nose
}:

buildPythonPackage rec {
  pname = "srvlookup";
  version = "2.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1zf1v04zd5phabyqh0nhplr5a8vxskzfrzdh4akljnz1yk2n2a0b";
  };

  propagatedBuildInputs = [ dnspython ];
  checkInputs = [ mock nose ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/gmr/srvlookup";
    license = [ licenses.bsd3 ];
    description = "A small wrapper for dnspython to return SRV records for a given host, protocol, and domain name as a list of namedtuples.";
    maintainers = [ maintainers.mmlb ];
  };
}
