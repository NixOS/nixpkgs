{ lib, mkDiscoursePlugin, fetchFromGitHub }:

mkDiscoursePlugin {
  name = "discourse-ldap-auth";
  bundlerEnvArgs.gemdir = ./.;
  src = fetchFromGitHub {
    owner = "jonmbake";
    repo = "discourse-ldap-auth";
    rev = "2f7a04b9fbeda0c8ab5c70e9012e4914ede9a707";
    sha256 = "sha256-zBug9PHgvRsdQjvfWE5Bylm+0Ot+jBHFrbux7+Kn72c=";
  };
  meta = with lib; {
    homepage = "https://github.com/jonmbake/discourse-ldap-auth";
    maintainers = with maintainers; [ ryantm ];
    license = licenses.mit;
    description = "Discourse plugin to enable LDAP/Active Directory authentication.";
  };
}
