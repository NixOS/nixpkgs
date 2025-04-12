{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  poetry-core,
  openldap,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "slapd";
  version = "0.1.5";
  pyproject = true;

  disabled = pythonOlder "3.8";

  # Pypi tarball doesn't include tests/
  src = fetchFromGitHub {
    owner = "python-ldap";
    repo = "python-slapd";
    rev = "refs/tags/${version}";
    hash = "sha256-AiJvhgJ62vCj75m6l5kuIEb7k2qCh/QJybS0uqw2vBY=";
  };

  build-system = [ poetry-core ];

  nativeCheckInputs = [ pytestCheckHook ];

  preCheck = ''
    # Needed by tests to setup a mockup ldap server
    export BIN="${openldap}/bin"
    export SBIN="${openldap}/bin"
    export SLAPD="${openldap}/libexec/slapd"
    export SCHEMA="${openldap}/etc/schema"
  '';

  pythonImportsCheck = [ "slapd" ];

  meta = with lib; {
    description = "Controls a slapd process in a pythonic way";
    homepage = "https://github.com/python-ldap/python-slapd";
    changelog = "https://github.com/python-ldap/python-slapd/blob/${src.rev}/CHANGES.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ erictapen ];
  };

}
