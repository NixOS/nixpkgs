{ stdenv, buildPythonPackage, fetchPypi
, netifaces, six, enum-compat }:

buildPythonPackage rec {
  pname = "zeroconf";
  version = "0.20.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "6e3f1e7b5871e3d1410ac29b9fb85aafc1e2d661ed596b07a6f84559a475efcb";
  };

  propagatedBuildInputs = [ netifaces six enum-compat ];

  meta = with stdenv.lib; {
    description = "A pure python implementation of multicast DNS service discovery";
    homepage = https://github.com/jstasiak/python-zeroconf;
    license = licenses.lgpl21;
    maintainers = with maintainers; [ abbradar ];
  };
}
