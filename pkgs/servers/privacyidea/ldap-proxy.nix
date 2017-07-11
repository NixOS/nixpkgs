{ stdenv, pythonPackages, fetchFromGitHub }:

pythonPackages.buildPythonApplication rec {
  name = "privacyidea-ldap-proxy-${version}";
  version = "0.3";

  src = fetchFromGitHub {
    owner = "NetKnights-GmbH";
    repo = "privacyidea-ldap-proxy";
    rev = "v${version}";
    sha256 = "0g2idpkp3wagkrn7v6wngsi6jkhp5c13npypk56gv6fndwdg6140";
  };

  checkPhase = ''
    trial pi_ldapproxy.test
  '';

  propagatedBuildInputs = with pythonPackages; [ twisted ldaptor configobj ];

  meta = with stdenv.lib; {
    description = "PrivacyIDEA LDAP Proxy";
    license = licenses.agpl3Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ fpletz globin ];
  };
}
