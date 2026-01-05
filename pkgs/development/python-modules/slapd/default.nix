{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  hatchling,
  openldap,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "slapd";
  version = "0.1.6";
  pyproject = true;

  disabled = pythonOlder "3.8";

  # Pypi tarball doesn't include tests/
  src = fetchFromGitHub {
    owner = "python-ldap";
    repo = "python-slapd";
    tag = version;
    hash = "sha256-xXIKC8xDJ3Q6yV1BL5Io0PkLqVbFRbbkB0QSXQGHMNg=";
  };

  build-system = [ hatchling ];

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
    changelog = "https://github.com/python-ldap/python-slapd/blob/${src.tag}/CHANGES.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ erictapen ];
  };

}
