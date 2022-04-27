{ lib, fetchPypi, buildPythonPackage
, dnspython
, mock, nose
}:

buildPythonPackage rec {
  pname = "srvlookup";
  version = "3.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-jA2WUB3wEXvOgqwgdqA6HEULykPcTPg+VLAm9sLtXD4=";
  };

  propagatedBuildInputs = [ dnspython ];
  checkInputs = [ mock nose ];

  meta = with lib; {
    homepage = "https://github.com/gmr/srvlookup";
    license = [ licenses.bsd3 ];
    description = "A small wrapper for dnspython to return SRV records for a given host, protocol, and domain name as a list of namedtuples.";
    maintainers = [ maintainers.mmlb ];
  };
}
