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
    rev = "0f5749ca6443d63999f78ed8eac49dead1b322bc";
    sha256 = "sha256-QquREAexMJjza+TtDveqJ3/sgjPCziv2oje4fKL6uz4=";
  };
  meta = {
    homepage = "https://github.com/jonmbake/discourse-ldap-auth";
    maintainers = with lib.maintainers; [ ryantm ];
    license = lib.licenses.mit;
    description = "Discourse plugin to enable LDAP/Active Directory authentication";
  };
}
