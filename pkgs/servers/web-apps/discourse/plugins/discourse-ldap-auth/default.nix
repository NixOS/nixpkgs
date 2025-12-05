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
    rev = "fa1d661004ca99036ff628a9c4be12a81265d784";
    sha256 = "sha256-2DYrYgC3H+e8USoo1MbJin1f5tshIUsQa6J7avnpvEc=";
  };
  meta = with lib; {
    homepage = "https://github.com/jonmbake/discourse-ldap-auth";
    maintainers = with maintainers; [ ryantm ];
    license = licenses.mit;
    description = "Discourse plugin to enable LDAP/Active Directory authentication";
  };
}
