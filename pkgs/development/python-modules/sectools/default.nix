{ lib
, buildPythonPackage
, fetchFromGitHub
, ldap3
, pythonOlder
}:

buildPythonPackage rec {
  pname = "sectools";
  version = "1.3.9";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "p0dalirius";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-F9mmPSlfSSS7UDNuX9OPrqDsEpqq0bD3eROG8D9CC78=";
  };

  propagatedBuildInputs = [
    ldap3
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [
    "sectools"
  ];

  meta = with lib; {
    description = "library containing functions to write security tools";
    homepage = "https://github.com/p0dalirius/sectools";
    changelog = "https://github.com/p0dalirius/sectools/releases/tag/${version}";
    license = with licenses; [ gpl3Only ];
    maintainers = with maintainers; [ fab ];
  };
}
