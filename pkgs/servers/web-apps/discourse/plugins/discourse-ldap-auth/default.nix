{
  lib,
  mkDiscoursePlugin,
  fetchFromGitHub,
}:

mkDiscoursePlugin {
  name = "discourse-ldap-auth";
  bundlerEnvArgs.gemdir = ./.;
  pluginName = "ldap";
  src = fetchFromGitHub {
    owner = "jonmbake";
    repo = "discourse-ldap-auth";
    rev = "1f225fa60e2cd580596aedd65d0fe76acd221c92";
    sha256 = "sha256-S51VoXqwcnRYuahfjA1eeonPgy2OZdhiEhlo+zzu//U=";
  };
  meta = {
    homepage = "https://github.com/jonmbake/discourse-ldap-auth";
    maintainers = with lib.maintainers; [ ryantm ];
    license = lib.licenses.mit;
    description = "Discourse plugin to enable LDAP/Active Directory authentication";
  };
}
