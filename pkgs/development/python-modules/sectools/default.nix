{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  ldap3,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "sectools";
  version = "1.4.4";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "p0dalirius";
    repo = "sectools";
    tag = version;
    hash = "sha256-dI0zokmndMZ4C7aX73WOdyXvOjCQJzZU6C1uXDt97Vg=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [ ldap3 ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "sectools" ];

  meta = with lib; {
    description = "library containing functions to write security tools";
    homepage = "https://github.com/p0dalirius/sectools";
    changelog = "https://github.com/p0dalirius/sectools/releases/tag/${src.tag}";
    license = with licenses; [ gpl3Only ];
    maintainers = with maintainers; [ fab ];
  };
}
