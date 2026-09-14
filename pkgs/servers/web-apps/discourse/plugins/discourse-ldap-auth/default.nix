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
    rev = "9776c1d021696e5bfdb8857093b8434063bc6ae1";
    sha256 = "sha256-ZXYuplYF1xjxqcKT7+u/zkjh0fCmIgQ+cWBhs7NFm14=";
  };
  meta = {
    homepage = "https://github.com/jonmbake/discourse-ldap-auth";
    maintainers = with lib.maintainers; [ ryantm ];
    license = lib.licenses.mit;
    description = "Discourse plugin to enable LDAP/Active Directory authentication";
  };
}
