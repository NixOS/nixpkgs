{
stdenv, lib, buildPythonPackage, fetchPypi,
netifaces, six, enum-compat
}:

buildPythonPackage rec {
  pname = "zeroconf";
  version = "0.18.0";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0s1840v2h4h19ad8lfadbm3dhzs8bw9c5c3slkxql1zsaiycvjy2";
  };

  propagatedBuildInputs = [ netifaces six enum-compat ];

  meta = {
    description = "A pure python implementation of multicast DNS service discovery";
    homepage = "https://github.com/jstasiak/python-zeroconf";
    license = lib.licenses.lgpl21;
    maintainers = with lib.maintainers; [ abbradar ];
  };
}
