{ lib, mkDiscoursePlugin, fetchFromGitHub }:

mkDiscoursePlugin {
  name = "discourse-ldap-auth";
  bundlerEnvArgs.gemdir = ./.;
  src = fetchFromGitHub {
    owner = "jonmbake";
    repo = "discourse-ldap-auth";
    rev = "a7a2e35eb5a8f6ee3b90bf48424efcb2a66c9989";
    sha256 = "sha256-Dsb12bZEZlNjFGw1GX7zt2hDVM9Ua+MDWSmBn4HEvs0=";
  };
  meta = with lib; {
    homepage = "https://github.com/jonmbake/discourse-ldap-auth";
    maintainers = with maintainers; [ ryantm ];
    license = licenses.mit;
    description = "Discourse plugin to enable LDAP/Active Directory authentication.";
  };
}
