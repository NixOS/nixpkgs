{ lib, mkDiscoursePlugin, fetchFromGitHub }:

mkDiscoursePlugin {
  name = "discourse-ldap-auth";
  bundlerEnvArgs.gemdir = ./.;
  src = fetchFromGitHub {
    owner = "jonmbake";
    repo = "discourse-ldap-auth";
    rev = "eca02c560f2f2bf42feeb1923bc17e074f16b891";
    sha256 = "sha256-HLNoDvvxkBMvqP6WbRrJY0CYnK92W77nzSpuwgl0VPA=";
  };
  meta = with lib; {
    homepage = "https://github.com/jonmbake/discourse-ldap-auth";
    maintainers = with maintainers; [ ryantm ];
    license = licenses.mit;
    description = "Discourse plugin to enable LDAP/Active Directory authentication.";
  };
}
