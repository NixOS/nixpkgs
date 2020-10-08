{ isPy3k, buildPythonPackage, fetchPypi, service-identity, ldap3, twisted, ldaptor, mock }:

buildPythonPackage rec {
  pname = "matrix-synapse-ldap3";
  version = "0.1.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "01bms89sl16nyh9f141idsz4mnhxvjrc3gj721wxh1fhikps0djx";
  };

  propagatedBuildInputs = [ service-identity ldap3 twisted ];

  # ldaptor is not ready for py3 yet
  doCheck = !isPy3k;
  checkInputs = [ ldaptor mock ];
}
