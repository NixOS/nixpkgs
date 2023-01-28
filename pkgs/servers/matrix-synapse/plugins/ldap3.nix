{ isPy3k, buildPythonPackage, fetchPypi, service-identity, ldap3, twisted, ldaptor, mock }:

buildPythonPackage rec {
  pname = "matrix-synapse-ldap3";
  version = "0.1.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "9fdf8df7c8ec756642aa0fea53b31c0b2f1924f70d7f049a2090b523125456fe";
  };

  propagatedBuildInputs = [ service-identity ldap3 twisted ];

  # ldaptor is not ready for py3 yet
  doCheck = !isPy3k;
  nativeCheckInputs = [ ldaptor mock ];
}
