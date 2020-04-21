{ lib, buildPythonPackage, fetchFromGitHub, twisted, ldaptor, configobj }:

buildPythonPackage rec {
  pname = "privacyidea-ldap-proxy";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "privacyidea";
    repo = pname;
    rev = "v${version}";
    sha256 = "1kc1n9wr1a66xd5zvl6dq78xnkqkn5574jpzashc99pvm62dr24j";
  };

  propagatedBuildInputs = [ twisted ldaptor configobj ];
  doCheck = false;

  meta = with lib; {
    description = "LDAP Proxy to intercept LDAP binds and authenticate against privacyIDEA";
    homepage = "https://github.com/privacyidea/privacyidea-ldap-proxy";
    license = licenses.agpl3;
    maintainers = [ maintainers.globin ];
  };
}
