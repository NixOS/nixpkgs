{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  ldap3,
  setuptools,
}:

buildPythonPackage rec {
  pname = "sectools";
  version = "1.5.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "p0dalirius";
    repo = "sectools";
    tag = version;
    hash = "sha256-P0ixL6zdEcvL7KKbr1LcJyd8mqPZrwklspJmZ/KokEA=";
  };

  build-system = [ setuptools ];

  dependencies = [ ldap3 ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "sectools" ];

  meta = with lib; {
    description = "Library containing functions to write security tools";
    homepage = "https://github.com/p0dalirius/sectools";
    changelog = "https://github.com/p0dalirius/sectools/releases/tag/${src.tag}";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ fab ];
  };
}
