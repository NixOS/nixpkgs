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
  version = "0.1.4";
  pyproject = true;

  disabled = pythonOlder "3.8";

  # Pypi tarball doesn't include tests/
  src = fetchFromGitHub {
    owner = "python-ldap";
    repo = "python-slapd";
    rev = version;
    hash = "sha256-C0nIZfDtVnIS2E2j+D5KDi80Ql7Oq82jK6BsxdFHYJ8=";
  };

  # See https://github.com/NixOS/nixpkgs/issues/103325
  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace "poetry>=1.0.0" "poetry-core" \
      --replace "poetry.masonry.api" "poetry.core.masonry.api"
  '';

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
    homepage = "https://github.com/python-ldap/python-slapd/tree/main";
    changelog = "https://github.com/python-ldap/python-slapd/blob/main/CHANGES.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ erictapen ];
  };

}
