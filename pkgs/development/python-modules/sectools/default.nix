{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  ldap3,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "sectools";
  version = "1.5.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "p0dalirius";
    repo = "sectools";
    tag = finalAttrs.version;
    hash = "sha256-iZV7FFfzvirHj4Q2HZQPQTcMIQ7mpc4zQYWAnFwf+q8=";
  };

  build-system = [ setuptools ];

  dependencies = [ ldap3 ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "sectools" ];

  meta = {
    description = "Library containing functions to write security tools";
    homepage = "https://github.com/p0dalirius/sectools";
    changelog = "https://github.com/p0dalirius/sectools/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ fab ];
  };
})
