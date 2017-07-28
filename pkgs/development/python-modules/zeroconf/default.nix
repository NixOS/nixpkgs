{ stdenv, buildPythonPackage, fetchPypi
, netifaces, six, enum-compat }:

buildPythonPackage rec {
  pname = "zeroconf";
  version = "0.19.1";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0ykzg730n915qbrq9bn5pn06bv6rb5zawal4sqjyfnjjm66snkj3";
  };

  propagatedBuildInputs = [ netifaces six enum-compat ];

  meta = with stdenv.lib; {
    description = "A pure python implementation of multicast DNS service discovery";
    homepage = "https://github.com/jstasiak/python-zeroconf";
    license = licenses.lgpl21;
    maintainers = with maintainers; [ abbradar ];
  };
}
