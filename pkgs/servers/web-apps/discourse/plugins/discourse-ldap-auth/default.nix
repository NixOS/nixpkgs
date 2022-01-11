{ lib, mkDiscoursePlugin, fetchFromGitHub }:

mkDiscoursePlugin {
  name = "discourse-ldap-auth";
  bundlerEnvArgs.gemdir = ./.;
  src = fetchFromGitHub {
    owner = "jonmbake";
    repo = "discourse-ldap-auth";
    rev = "1c10221836393c3cfac470a7b08de6f31150c802";
    sha256 = "sha256-IiAl3OTADXSUnL+OKKHJY9Xqd4zCNJ2wOrgTN3nm5Yw=";
  };
  meta = with lib; {
    homepage = "https://github.com/jonmbake/discourse-ldap-auth";
    maintainers = with maintainers; [ ryantm ];
    license = licenses.mit;
    description = "Discourse plugin to enable LDAP/Active Directory authentication.";
  };
}
